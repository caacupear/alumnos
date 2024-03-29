---
title: AsistenciaTriggerHandler
---

## Introducción

<!-- START autogenerated-class -->
## Descripción



- Status: Active
- Api Version: 58
- Creada: 2 de noviembre de 23
- Modificada: 21 de noviembre de 23
- Interface 
        * [TriggerHandler](/diccionarios/classes/TriggerHandler)

## Diagrama
```mermaid
classDiagram

class AsistenciaTriggerHandler {
     triggerIsExecuting     
     triggerSize     
     AsistenciaTriggerHandler(Boolean triggerIsExecutingInteger triggerSize)  
     beforeInsert(List newAsistencias) void 
     beforeUpdate(List newAsistenciasList oldAsistenciasMap newAsistenciaMapMap oldAsistenciaMap) void 
     beforeDelete(List oldAsistenciasMap oldAsistenciaMap) void 
     afterInsert(List newAsistenciasMap newAsistenciaMap) void 
     afterUpdate(List newAsistenciasList oldAsistenciasMap newAsistenciaMapMap oldAsistenciaMap) void 
     afterDelete(List oldAsistenciasMap oldAsistenciaMap) void 
     afterUndelete(List newAsistenciasMap newAsistenciaMap) void 

}
```


### Metodos
*Constructores*
| #   | Argumentos |
| --- | ---------- |
| <div class="icons"></div> | <ul><li>Boolean triggerIsExecuting</li><li>Integer triggerSize</li></ul>|

*Metodos*
| #   | Nombre | Return | Argumentos |
| --- | ------ | ------ | ---------- |
| <div class="icons"></div> | beforeInsert | void| <ul><li>List newAsistencias</li></ul>|
| <div class="icons"></div> | beforeUpdate | void| <ul><li>List newAsistencias</li><li>List oldAsistencias</li><li>Map newAsistenciaMap</li><li>Map oldAsistenciaMap</li></ul>|
| <div class="icons"></div> | beforeDelete | void| <ul><li>List oldAsistencias</li><li>Map oldAsistenciaMap</li></ul>|
| <div class="icons"></div> | afterInsert | void| <ul><li>List newAsistencias</li><li>Map newAsistenciaMap</li></ul>|
| <div class="icons"></div> | afterUpdate | void| <ul><li>List newAsistencias</li><li>List oldAsistencias</li><li>Map newAsistenciaMap</li><li>Map oldAsistenciaMap</li></ul>|
| <div class="icons"></div> | afterDelete | void| <ul><li>List oldAsistencias</li><li>Map oldAsistenciaMap</li></ul>|
| <div class="icons"></div> | afterUndelete | void| <ul><li>List newAsistencias</li><li>Map newAsistenciaMap</li></ul>|


| #  | Referencia       | #  | Referencia |
| -- | ---------------- | -- | ---------- |
| +  | public or global | #  | protected  |
| -  | private          | ~  | Package    |
| $  | final or static  | *  | abstract   |

<!-- END autogenerated-class -->
