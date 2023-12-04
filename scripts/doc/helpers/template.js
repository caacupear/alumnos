const Handlebars = require('handlebars');
const fs = require('fs');
const {merge} = require('./merge');

const TEMPLATE_ROOT_FOLDER = process.cwd() + '/templates';

function isObjectEmpty (objectName) {
    return Object.keys(objectName).length === 0 && objectName.constructor === Object;
}


function getFiles(source ) {
    const files = []
    for (const file of fs.readdirSync(source)) {
        const fullPath = source + '/' + file;
        if(fs.lstatSync(fullPath).isDirectory()) {
            getFiles(fullPath).forEach(x => files.push(file + '/' + x))
        } else {
            files.push(file)
        }
    }
    return files;
}

module.exports = (source, extension) => {
    const sourceFolder = `${TEMPLATE_ROOT_FOLDER}/${source}`;
    if ( !fs.existsSync(sourceFolder) ) {
        throw new Error(`La carpeta source ${sourceFolder} no existe!`);
    }
    
    let _template;
    let _rendered;

    return {
        getTemplates: () => {
            const templates = [];
            const files = getFiles( sourceFolder );
            for ( filename of files ){
                const [name, ext] = filename.split('.');
                if ( ext === extension ){
                    templates.push(name);
                } 
            }
            return templates;
        },
        read: (templateName) => {
            const source = `${sourceFolder}/${templateName}.${extension}`;
            const rawTemplate = fs.readFileSync( source, 'utf8');
            this._template =  Handlebars.compile(rawTemplate);
        }, 
        render: (context, options) => {
            if (isObjectEmpty(context)) {
                return;
            }            
            this._rendered =  this._template(context, options);
        },
        
        save: ( filename, folder ) => {
            let accion = 'creo';
            if ( folder && !fs.existsSync(folder) ) {
                throw new Error(`La carpeta ${folder} no existe!`);
            }
            const destination = folder ? `${folder}/${filename}.${extension}`: `${filename}.${extension}`;

            let content = this._rendered;

            if ( fs.existsSync(destination) ) {
                accion = 'combino'
                const existingContent = fs.readFileSync( destination, 'utf8');                
                content = merge( content , existingContent);
            }

            fs.writeFileSync( destination, content);
            console.log( `Se ${accion} el archivo ${filename} con exito!`);
        }    
    }
}