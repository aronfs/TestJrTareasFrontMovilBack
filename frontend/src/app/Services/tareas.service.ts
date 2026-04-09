import { Injectable } from "@angular/core";
import { enviroment } from "../../environments/enviroment";
import { HttpClient } from "@angular/common/http";
import { Observable } from "rxjs";
import { ResponseApi } from "../Interfaces/response-api";
import { tareas } from "../Interfaces/tareas";

@Injectable({
    providedIn: 'root'
})
export class TareasService {

    private urlApi: string = enviroment.endpoint + "Tareas/";
    constructor(private http: HttpClient) { }

    lista(id:number): Observable<ResponseApi> {
        return this.http.get<ResponseApi>(`${this.urlApi}Lista/${id}`);
    }

    guardar(request: tareas): Observable<ResponseApi> {
        return this.http.post<ResponseApi>(`${this.urlApi}Guardar`, request);
    }

    editar(request: tareas): Observable<ResponseApi> {
        return this.http.put<ResponseApi>(`${this.urlApi}Editar`, request);
    }

    completarTarea(id: number): Observable<ResponseApi> {
        return this.http.put<ResponseApi>(`${this.urlApi}CompletarTarea/${id}`, id);
    }

    inactivarTarea(id: number): Observable<ResponseApi> {
        return this.http.put<ResponseApi>(`${this.urlApi}Inactivar_Tarea/${id}`, id);
    }

    eliminar(id: number): Observable<ResponseApi> {
        return this.http.delete<ResponseApi>(`${this.urlApi}Eliminar/${id}`);
    }


}