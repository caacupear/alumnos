---
sidebar_position: 1
tags: [secretaria]
---

# Crear un Nuevo Ciclo Lectivo

## Contexto

- Cuando: A partir de finalizar un ciclo lectivo, se puede crear uno nuevo
- Precondición: Haber ingresado al sistema de Salesforce Caacupe
- Postcondición: Que todos los alumnos que cumplan los requisitos (ver en detalle) pasen al siguiente grado.
- Actores: [Secretaria](/tags/secretaria)

## Pasos:

Apretar el botón “Nuevo Ciclo Lectivo”
Ingresar el programa y el nombre
Cambia el status de los boletines vigentes
Para todos los alumnos del último año del programa que cumplan los requisitos los cambia al estado “Egresado”
Para todos los demás alumnos que cumplan los requisitos los pasa al próximo año:
Crear los boletines nuevos
Crear un item nuevo en la lista de ciclos Lectivos
