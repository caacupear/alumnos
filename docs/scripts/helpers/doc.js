const fs = require('fs');
const prompts = require('prompts');

// Logica especificas de cada componente
const helpers = {
    'object': require( './object'),
    'class': require( './class'),
    'omni': require( './omni'),
    'new': require( './new'),
}

async function prompt(config) {
    const componentes = Object.keys(helpers);
    const componenteInvalido =  !componentes.includes(config.componente);
    if ( componenteInvalido ) {
        config.componente = undefined;
    }
    if ( !config.componente) {
        const response = await prompts({
            type: 'select',
            name: 'componente',
            initial: config.componente,
            message: componenteInvalido ? 'El componente no es valido, seleccione uno por favor':  'Seleccione un Componente',
            choices: componentes.map( componente => {
                return { title: componente, value: componente}
            }),        
        });    
        config.componente = response.componente;
    }
}    

function help() {

}

function newArgument(argumentos) {
    return { template: argumentos[0], filename: argumentos[1], context: argumentos[2]};
}

function dictionaryArguments(argumentos) {
    // Si viene una lista de items
    if ( Array.isArray(argumentos) && argumentos.length > 1 ) {
        return {items: argumentos};
    }
        
    const argumento = argumentos[0] || argumentos;

    // argumento especial * bajaria todo de SF
    if ( argumento === '*' ) {

    }

    // argumento especial refresh baja todo lo que esta en el directorio
    if ( argumento === 'refresh' ) {

    }

    return Array.isArray(argumentos) ? {items: argumento} : {items: [argumento]}
}
async function execute({componente, argumentos}) {
    const helper = helpers[componente];
    
    if ( argumentos[1] === 'help' ) {
        helper.help();
    } else {
        const config = componente === 'new' ? newArgument(argumentos): dictionaryArguments(argumentos);

        if( typeof helper.prompt === 'function') {
            await helper.prompt(config);
        }
        const context = await helper.execute(config);

    }
    
}

module.exports = {
    prompt,
    help,
    execute
};
