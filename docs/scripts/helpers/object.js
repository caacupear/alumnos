const  sf = require( './connect');
const prompts = require('prompts');
const templateEngine = require( './template')('dictionary', 'md');
const DICTIONARY_FOLDER = process.cwd() + '/docs/diccionarios/objects';
const WORKING_FOLDER = process.env.INIT_CWD || '.';
const fs = require('fs');

async function getContext(objetos) {
    try {
        await sf.connect();        
        const objects = await sf.customObjects(objetos);

        return objects;
    } catch(e) {
        console.error(e);
    }
}

async function prompt(config) {    
    if ( !config.items || config.items.length === 0) {
        const response = await prompts({
            type: 'text',
            name: 'object',
            initial: config.argumentos,
            message:'Ingrese el api name del objeto',
        });    
        config.items = response.object;
    }
}

function help() {
    console.error('Puede llamarse con el api name de un objeto o varios, de la siguiente forma:');
    console.error('Ej single object: npm run generate datos objeto');
    console.error('Ej multi object: npm run generate datos objeto1 objeto2 objeto3');
}

async function execute({items}) { 
    if ( !items || items.length === 0 ) {
        return;
    }
    const contexts = await getContext(items);
    if ( !contexts || contexts.length === 0 ) {
        return;
    }

    if ( !Array.isArray(contexts) ) {            
        contexts = [contexts];
    }
    // Arma el diccionario de cada Objeto
    templateEngine.read('object');
    for (const context of contexts ) {
        templateEngine.render(context);
        templateEngine.save(context.fullName, DICTIONARY_FOLDER)
    }
    
    // Arma el documento indice del grupo de objetos
    templateEngine.read('objects');
    const objectContext = { objects: contexts };    
    fs.writeFileSync( WORKING_FOLDER + '.objects.json', JSON.stringify(objectContext) );
    templateEngine.render( objectContext );
    templateEngine.save('objects', WORKING_FOLDER);    
}

module.exports = {
    help,
    prompt,
    execute
};