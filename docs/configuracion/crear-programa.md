---
sidebar_position: 1
tags: [secretaria]
---

# Crear un Programa

## Contexto

- Cuando: En la migración inicial o eventualmente si se abren nuevos programas de estudio
- Precondición: Haber ingresado al sistema de Salesforce Caacupe
- Postcondición: Que estén cargadas todas las materias del programa con todas las reglas necesarias
- Actores: [Secretaria](/tags/secretaria)

## Flujo Principal

## Flujos Alternativos

## Modelo de Datos

```mermaid
erDiagram
            Programa__c ||..|{ ProgramaEvaluacion__c : "Evaluaciones de los programas"
            TipoEvaluacion__c ||..|{ ProgramaEvaluacion__c : "Evaluaciones de los programas"
            Programa__c ||..|{ Materia__c : "Materias"
            TipoEvaluacion__c ||..|{ TipoEvaluacionOpcion__c : "Tipo de Evaluacion Opciones"

ProgramaEvaluacion__c {
            Programa__c Programa__c
            TipoEvaluacion__c TipoEvaluacion__c
}
Materia__c {
            Programa__c Programa__c
}
Programa__c {
}
TipoEvaluacion__c {
}
TipoEvaluacionOpcion__c {
            TipoEvaluacion__c TipoEvaluacion__c
}

```
