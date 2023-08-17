import { LightningElement,track, api, wire } from 'lwc';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class PhotoUpload extends LightningElement {
  @api recordId;
  @api objectApiName = 'Materia__c';
  hasImage = false;
  disableUpload = false;
  @track _image;

  get disabledClass() {
    return this.disableUpload ? 'disabled': '';
  }
  get acceptedFormats() {
      return ['.jpg','.png'];
  }
  get image() { return this._image}

  get fields() { 
    return [{ objectApiName: this.objectApiName, fieldApiName: 'imagen__c'}];
  }

  @wire(getRecord, { recordId: '$recordId', fields: '$fields' }) getData( {data, error}) {
    if ( data ) {
        this.hasImage = true;
        this._image = data.fields.imagen__c.value;
      }
    if ( error){
      console.log(error)
    }
  }

  async updateImageField(imageUrl) {
    try {
      const fields = {'Id': this.recordId, 'imagen__c': imageUrl };
      const recordInput = { fields };
            
      await updateRecord(recordInput);
        this.hasImage = true;
        this._image = imageUrl;
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Exitoso",
            message: "Se subio la imagen",
            variant: "success",
          }),
        );
    } catch( error ) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Ups no se pudo adjuntar la imagen",
          message: error.body.message,
          variant: "error",
        }),
      );}
    }

  async handleUploadFinished(event) {
    const uploadedFiles = event.detail.files;
    if(uploadedFiles && uploadedFiles.length == 1){
      const imageUrl = '/sfc/servlet.shepherd/version/download/' + uploadedFiles[0].contentVersionId;
      this.disableUpload = true;
      await this.updateImageField(imageUrl);
      this.disableUpload = false;
    } else {
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Ups no se subio la imagen",
          message: `Por favor intente subir una sola imagen de tipo ${acceptedFormats}`,
          variant: "error",
        }),
      );

    }
  }
}