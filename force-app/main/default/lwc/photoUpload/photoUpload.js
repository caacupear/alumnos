import { LightningElement,api } from 'lwc';

export default class PhotoUpload extends LightningElement {
  @api recordId;
  newFileWasUploaded = false;
  uploadedFilesUrl = [];

  get acceptedFormats() {
      return ['.jpg','.png'];
  }

  handleUploadFinished(event) {
      const uploadedFiles = event.detail.files;
      if(uploadedFiles && uploadedFiles.length > 0){
          this.newFileWasUploaded = true;
          uploadedFiles.forEach(element => {
              this.uploadedFilesUrl.push({
                  id : '/sfc/servlet.shepherd/version/download/' + element.contentVersionId
              })
          });
      }
  }
}