import { LightningElement,api,wire,track } from 'lwc';
import {NavigationMixin} from 'lightning/navigation'
import getRelatedFilesByRecordId from '@salesforce/apex/filePreviewAndDownloadController.getRelatedFilesByRecordId'
export default class FileViewer extends NavigationMixin(LightningElement) {
    @api recordId='0030k00001TyAZKAA3'
    filesList =[]
    @wire(getRelatedFilesByRecordId, {recordId: '$recordId'})
    wiredResult({data, error}){ 
        if(data){ 
            console.log(data)
            this.filesList = Object.keys(data).map(item=>({"label":data[item],
             "value": item,
             "url":`/sfc/servlet.shepherd/document/download/${item}`
            }))
            console.log(this.filesList)
        }
        if(error){ 
            console.log(error)
        }
    }
    previewHandler(event){
        console.log(event.target.dataset.id)
        this[NavigationMixin.Navigate]({ 
            type:'standard__namedPage',
            attributes:{ 
                pageName:'filePreview'
            },
            state:{ 
                selectedRecordId: event.target.dataset.id
            }
        })
    }
}