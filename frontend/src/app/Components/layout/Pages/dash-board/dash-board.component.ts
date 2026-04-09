import { Component, OnDestroy, OnInit } from '@angular/core';
import { Chart, registerables } from 'chart.js';
import { CdkDragDrop, moveItemInArray, transferArrayItem } from '@angular/cdk/drag-drop';
import { jwtDecode } from 'jwt-decode';
import { DashBoardService } from '../../../../Services/dash-board.service';
import { TareasService } from '../../../../Services/tareas.service';
import { UsuarioService } from '../../../../Services/usuario.service';
import { UtilidadService } from '../../../../Reutilizable/utilidad.service';
import { tareas } from '../../../../Interfaces/tareas';
import { Usuario } from '../../../../Interfaces/usuario';
Chart.register(...registerables);

type TaskStage = 'para-hacer' | 'en-proceso' | 'finalizado';

interface DashboardTask extends tareas {
  stage: TaskStage;
}

@Component({
  selector: 'app-dash-board',
  standalone: false,
  templateUrl: './dash-board.component.html',
  styleUrl: './dash-board.component.css'
})
export class DashBoardComponent implements OnInit, OnDestroy {

  totalIngresos: string = '0';
  totalVentas: string = '0';
  totalProductos: string = '0';
  correoUsuario: string = '';
  usuarioId: number | null = null;
  totalTareasTiempoReal = 0;
  socketConectado = false;
  paraHacer: DashboardTask[] = [];
  enProceso: DashboardTask[] = [];
  finalizado: DashboardTask[] = [];
  readonly storageKey = 'dashboard-task-stage';
  private socket: WebSocket | null = null;
  private reconnectTimer: ReturnType<typeof setTimeout> | null = null;
  private readonly socketUrl = 'ws://127.0.0.1:8181';
  private componentDestroyed = false;

  constructor(
    private _dashBoardService: DashBoardService,
    private _tareasService: TareasService,
    private _usuarioServicio: UsuarioService,
    private _utilidadService: UtilidadService
  ) { }

  mostrarGraficao(labelGrafico: any[], dataGrafico: any[]) {
    const chartBarras = new Chart('graficoBarras', {
      type: 'bar',
      data: {
        labels: labelGrafico,
        datasets: [{
          label: '# Ventas',
          data: dataGrafico,
          backgroundColor: 'rgba(208, 111, 95, 0.28)',
          borderColor: '#d06f5f',
          borderWidth: 2,
          borderRadius: 12,
          hoverBackgroundColor: 'rgba(208, 111, 95, 0.38)'
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: {
            labels: {
              color: '#5d534d'
            }
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              color: '#7a7068'
            },
            grid: {
              color: 'rgba(130, 124, 115, 0.12)'
            }
          },
          x: {
            ticks: {
              color: '#7a7068'
            },
            grid: {
              display: false
            }
          }
        }
      }
    });
  }

  ngOnInit(): void {
    this.cargarResumen();
    this.obtenerTareasDashboard();
  }

  ngOnDestroy(): void {
    this.componentDestroyed = true;
    this.cerrarSocket();
  }

  cargarResumen() {
    this._dashBoardService.resumen().subscribe({
      next: data => {
        if (data.status) {
          this.totalIngresos = data.value.totalIngresos;
          this.totalVentas = data.value.totalVentas;
          this.totalProductos = data.value.totalProductos;

          const arrayData: any[] = data.value.ventaUltimaSemana;
          const labelTemp = arrayData.map(item => item.fecha);
          const dataTemp = arrayData.map(item => item.total);

          this.mostrarGraficao(labelTemp, dataTemp);
        }
      },
      error: error => {
        console.error(error);
      }
    });
  }

  obtenerTareasDashboard() {
    const token = this._utilidadService.obtenerToken();
    if (token) {
      try {
        const usuario: any = jwtDecode(token);
        this.correoUsuario = usuario['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'];
      } catch (error) {
        console.error('Error al decodificar el token:', error);
      }
    }

    this._usuarioServicio.lista().subscribe({
      next: (response) => {
        if (!response.status) {
          return;
        }

        const usuarios = response.value;
        const usuarioEncontrado = usuarios.find((usuario: Usuario) => usuario.correo === this.correoUsuario);

        if (!usuarioEncontrado) {
          return;
        }

        this.usuarioId = usuarioEncontrado.idUsuario;
        this.conectarSocket();

        this._tareasService.lista(usuarioEncontrado.idUsuario).subscribe({
          next: (taskResponse) => {
            if (taskResponse.status) {
              this.organizarTareas(taskResponse.value as tareas[]);
            }
          }
        });
      }
    });
  }

  organizarTareas(tareasApi: tareas[]) {
    const savedStages = this.obtenerStagesGuardados();
    const normalizedTasks: DashboardTask[] = tareasApi
      .filter((task) => !task.inactivo)
      .map((task) => {
        const completada = (task as any).estado_Tarea ?? task.estado_tarea;
        const savedStage = savedStages[task.idTarea];

        let stage: TaskStage = 'para-hacer';
        if (completada) {
          stage = 'finalizado';
        } else if (savedStage === 'en-proceso') {
          stage = 'en-proceso';
        }

        return {
          ...task,
          stage
        };
      });

    this.paraHacer = normalizedTasks.filter(task => task.stage === 'para-hacer');
    this.enProceso = normalizedTasks.filter(task => task.stage === 'en-proceso');
    this.finalizado = normalizedTasks.filter(task => task.stage === 'finalizado');
    this.totalTareasTiempoReal = this.finalizado.length;
  }

  drop(event: CdkDragDrop<DashboardTask[]>, targetStage: TaskStage) {
    if (event.previousContainer === event.container) {
      moveItemInArray(event.container.data, event.previousIndex, event.currentIndex);
      this.persistirStages();
      return;
    }

    const tarea = event.previousContainer.data[event.previousIndex];

    if (targetStage === 'finalizado' && tarea.idTarea) {
      this._tareasService.completarTarea(tarea.idTarea).subscribe({
        next: (response) => {
          if (response.status) {
            transferArrayItem(
              event.previousContainer.data,
              event.container.data,
              event.previousIndex,
              event.currentIndex
            );
            tarea.stage = 'finalizado';
            this.persistirStages();
            this.totalTareasTiempoReal = this.finalizado.length;
          }
        }
      });
      return;
    }

    if (tarea.stage === 'finalizado') {
      return;
    }

    transferArrayItem(
      event.previousContainer.data,
      event.container.data,
      event.previousIndex,
      event.currentIndex
    );
    tarea.stage = targetStage;
    this.persistirStages();
    this.totalTareasTiempoReal = this.finalizado.length;
  }

  obtenerStagesGuardados(): Record<number, TaskStage> {
    const raw = localStorage.getItem(this.storageKey);
    if (!raw) {
      return {};
    }

    try {
      return JSON.parse(raw);
    } catch {
      return {};
    }
  }

  persistirStages() {
    const payload: Record<number, TaskStage> = {};

    this.paraHacer.forEach(task => payload[task.idTarea] = 'para-hacer');
    this.enProceso.forEach(task => payload[task.idTarea] = 'en-proceso');
    this.finalizado.forEach(task => payload[task.idTarea] = 'finalizado');

    localStorage.setItem(this.storageKey, JSON.stringify(payload));
  }

  conectarSocket() {
    if (!this.usuarioId || this.socket) {
      return;
    }

    this.socket = new WebSocket(this.socketUrl);

    this.socket.onopen = () => {
      this.socketConectado = true;
      this.socket?.send(String(this.usuarioId));
    };

    this.socket.onmessage = (event) => {
      try {
        const data = JSON.parse(event.data);
        if (data?.ok && Number(data.idUsuario) === this.usuarioId) {
          this.totalTareasTiempoReal = Number(data.total) || 0;
        }
      } catch (error) {
        console.error('No se pudo leer el mensaje del socket:', error);
      }
    };

    this.socket.onclose = () => {
      this.socketConectado = false;
      this.socket = null;
      if (!this.componentDestroyed) {
        this.programarReconexion();
      }
    };

    this.socket.onerror = () => {
      this.socketConectado = false;
    };
  }

  programarReconexion() {
    if (this.reconnectTimer || !this.usuarioId) {
      return;
    }

    this.reconnectTimer = setTimeout(() => {
      this.reconnectTimer = null;
      this.conectarSocket();
    }, 3000);
  }

  cerrarSocket() {
    if (this.reconnectTimer) {
      clearTimeout(this.reconnectTimer);
      this.reconnectTimer = null;
    }

    if (this.socket) {
      this.socket.close();
      this.socket = null;
    }
  }
}
