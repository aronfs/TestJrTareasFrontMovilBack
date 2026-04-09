using AutoMapper;
using Microsoft.EntityFrameworkCore;
using NetTopologySuite.Algorithm;
using SistemaVenta.BLL.Services.Contrato;
using SistemaVenta.DAL.Repositorios.Contrato;
using SistemaVenta.DTO;
using SistemaVenta.Model.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SistemaVenta.BLL.Services
{
    public class TareasService : ITareasService
    {

        private readonly IGenericRepository<Tareas> _tareasRepository;
        private readonly IMapper _mapper;

        public TareasService(IGenericRepository<Tareas> tareasRepository, IMapper mapper)
        {
            _tareasRepository = tareasRepository;
            _mapper = mapper;
        }

        public async Task<bool> Completar_Tarea(int id)
        {
            try {
                //var tareaModelo = _mapper.Map<Tareas>(tarea);
                var tareaEncontrada = await _tareasRepository.Obtener(x => x.IdTarea == id);

                if (tareaEncontrada == null)
                    throw new TaskCanceledException("La tarea no existe");

                tareaEncontrada.Estado_Tarea = true;

                bool completado = await _tareasRepository.Editar(tareaEncontrada);

                if (!completado)
                    throw new TaskCanceledException("No se pudo completar la tarea");
                return completado;
                 
            } catch { 
                throw; 
            }
        }

        public async Task<TareaDTO> Crear(TareaDTO tarea)
        {
            try {
                var tareaModelo = _mapper.Map<Tareas>(tarea);

                var tareaCreada = await _tareasRepository.Crear(tareaModelo);

                if (tareaCreada.IdTarea == 0)
                    throw new TaskCanceledException("No se pudo crear la tarea");

                return _mapper.Map<TareaDTO>(tareaCreada);
            }
            catch
            {
                throw;
            }
        }

        public async Task<bool> Editar(TareaDTO tarea)
        {
            try
            {
                var tareaModelo = _mapper.Map<Tareas>(tarea);
                var tareaEncontrada = await _tareasRepository.Obtener(x => x.IdTarea == tareaModelo.IdTarea);

                if (tareaEncontrada == null)
                    throw new TaskCanceledException("No se encontro ninguna tarea");
                tareaEncontrada.Titulo_Tarea = tareaModelo.Titulo_Tarea;
                tareaEncontrada.IdUsuario = tareaModelo.IdUsuario;
                tareaEncontrada.Descripcion = tareaModelo.Descripcion;
                tareaEncontrada.Comentario = tareaModelo.Comentario;

                bool respuesta = await _tareasRepository.Editar(tareaEncontrada);

                if (!respuesta)
                    throw new TaskCanceledException("No se pudo editar la tarea");
                return respuesta;

            }
            catch
            {
                throw;
            }
        }

        public async Task<bool> Eliminado_Logico(int id)
        {
            try
            {
                //var tareaModelo = _mapper.Map<Tareas>(tarea);
                var tareaEncontrada = await _tareasRepository.Obtener(x => x.IdTarea == id);

                if (tareaEncontrada == null)
                    throw new TaskCanceledException("La tarea no existe");

                tareaEncontrada.Inactivo = true;

                bool completado = await _tareasRepository.Editar(tareaEncontrada);

                if (!completado)
                    throw new TaskCanceledException("Tarea no se inactivo");
                return completado;

            }
            catch
            {
                throw;
            }
        }

        public async Task<bool> Eliminar(int id)
        {
            try {
                var tareaEncontrada = await _tareasRepository.Obtener(x => x.IdTarea == id);
                if (tareaEncontrada == null)
                    throw new TaskCanceledException("No se encontro la tarea");
                bool respuesta = await _tareasRepository.Eliminar(tareaEncontrada);

                if (!respuesta)
                    throw new TaskCanceledException("No se pudo eliminar la tarea");
                return respuesta;

            } catch { 
                throw; 
            }
            

        }

        public async Task<List<TareaListarDTO>> Lista(int id)
        {
            try {
                var queryTarea = await _tareasRepository.Consultar();
                var listaTareas = queryTarea.Where(u => u.IdUsuario == id && u.Inactivo == false
                    ).
                    Select(
                    t => new Tareas
                    {
                        IdTarea = t.IdTarea,
                        Titulo_Tarea = t.Titulo_Tarea,
                        Descripcion = t.Descripcion,
                        Comentario = t.Comentario,
                        Estado_Tarea = t.Estado_Tarea
                    }
                    ).ToList();
                return _mapper.Map<List<TareaListarDTO>>(listaTareas);
            } 
            catch { 
                throw; 
            }
        }

        public async Task<List<TareaListarDTO>> ListaCompletadas(int id)
        {
            try
            {
                var queryTarea = await _tareasRepository.Consultar();
                var listaTareasCompletadas = queryTarea
                    .Where(t => t.IdUsuario == id && t.Inactivo == false && t.Estado_Tarea == true)
                    .Select(t => new Tareas
                    {
                        IdTarea = t.IdTarea,
                        Titulo_Tarea = t.Titulo_Tarea,
                        Descripcion = t.Descripcion,
                        Comentario = t.Comentario,
                        Estado_Tarea = t.Estado_Tarea
                    })
                    .ToList();

                return _mapper.Map<List<TareaListarDTO>>(listaTareasCompletadas);
            }
            catch
            {
                throw;
            }
        }
    }
}
