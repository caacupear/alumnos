---
title: Modelo de datos
---

## Introducción

<!-- START autogenerated-objects -->

## Objetos

```mermaid
erDiagram
            Boletin__c ||..|{ Asistencia__c : "Asistencias"
            Contact ||..|{ Boletin__c : "Boletines"
            Division__c ||..|{ Boletin__c : "Boletines"
            Boletin__c ||..|{ Evaluacion__c : "Evaluaciones"
            Grilla__c ||..|{ Evaluacion__c : "Evaluaciones"
            TipoEvaluacionOpcion__c ||..|{ Evaluacion__c : "Evaluaciones"
            TipoEvaluacionOpcion__c ||..|{ Evaluacion__c : "Evaluaciones (Opcion2)"
            TipoEvaluacionOpcion__c ||..|{ Evaluacion__c : "Evaluaciones (Opcion3)"
            TipoEvaluacionOpcion__c ||..|{ Evaluacion__c : "Evaluaciones (Opcion4)"
            TipoEvaluacionOpcion__c ||..|{ Evaluacion__c : "Evaluaciones (Opcion5)"

Asistencia__c {
            Boletin__c Boletin__c
}
Boletin__c {
            Alumno__c Contact
            Division__c Division__c
}
Evaluacion__c {
            Boletin__c Boletin__c
            Grilla__c Grilla__c
            Opcion1__c TipoEvaluacionOpcion__c
            Opcion2__c TipoEvaluacionOpcion__c
            Opcion3__c TipoEvaluacionOpcion__c
            Opcion4__c TipoEvaluacionOpcion__c
            Opcion5__c TipoEvaluacionOpcion__c
}
 {
}

```

### Transaccionales

| #                         | Label                                                  | Api Name        | Descripcion                                     |
| ------------------------- | ------------------------------------------------------ | --------------- | ----------------------------------------------- |
| <div class="icons"></div> | [Asistencia](/docs/diccionarios/objects/Asistencia__c) | Asistencia\_\_c | Contiene las asistencias semanales de un alumno |
| <div class="icons"></div> | [Boletin](/docs/diccionarios/objects/Boletin__c)       | Boletin\_\_c    |                                                 |
| <div class="icons"></div> | [Evaluacion](/docs/diccionarios/objects/Evaluacion__c) | Evaluacion\_\_c |                                                 |
| <div class="icons"></div> | [](/docs/diccionarios/objects/)                        |                 |                                                 |

### Configuracion

| #   | Label | Api Name | Descripcion |
| --- | ----- | -------- | ----------- |

| #                                                              | Referencia    |
| -------------------------------------------------------------- | ------------- |
| <div class="icons">![Track History](/img/tracker_60.png)</div> | Track History |

<!-- END autogenerated-objects -->