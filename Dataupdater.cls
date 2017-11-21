/**
    * Webkul Software.
    *
    * @category  Webkul
    * @author    Webkul
    * @copyright Copyright (c) 2010-2016 Webkul Software Private Limited (https://webkul.com)
    * @license   https://store.webkul.com/license.html
    */
public with sharing class Dataupdater {
	
    /*
     * This variable will store the Schema of the entire Organization.
     */
    public Map <String, Schema.SObjectType> objectschemas= Schema.getGlobalDescribe();
    
    public String SelectedSObject {get; set;}
    
    public string fromField {get; set;}
    public string toField {get; set;}
    
    private string dataTyp;

    /*
     * This will generate a list of sObjects for the selection of the user
     */
    public List<SelectOption> getSobjectList() {
        List <SelectOption> SobjectList=new List<SelectOption>();
        
        //Iterating over the object list and adding them to the select options
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
            String name = objTyp.getDescribe().getName();
            SobjectList.add(new selectoption(name,name));
        }
        SobjectList.sort();
        return SobjectList;
    }

    /*
     * An empty pagereference method which is used as an action,
     * if the page needs to be rerendered without doing anything.
     */
    public pagereference showFields() {
        return null;
    }

    /*
     * This will return all the fields of the user selected sObject.
     */
    public list<selectOption> getFieldsOfObject() {

        Map <String, Schema.SObjectField> fieldMap = objectschemas.get(SelectedSObject).getDescribe().fields.getMap();
        List <SelectOption> fieldsofobject=new list<selectOption>();
        
        //Iterating over the field list of selected object and adding them to the select options
        for(Schema.SObjectField sfield : fieldMap.Values()){
            fieldsofobject.add(new selectoption(sfield.getdescribe().getname(),sfield.getdescribe().getname()));
        }
        fieldsofobject.sort();
        return fieldsOfObject;
    }
    
    /*
     * Checks if the object is accessible by the user.
     */
    public boolean isSafeObject(String ObjectName){
    
        if(objectschemas.get(ObjectName).getDescribe().isAccessible())
            return true;
        else{
            return false;
        }
    }
    
    /*
     * Checks if the field is accessible by the user.
     */
    public boolean isSafeField(String FieldName, String ObjectName){
        Map <String, Schema.SObjectField> fieldMap = objectSchemas.get(objectName).getDescribe().fields.getMap();
        if(fieldMap.get(FieldName).getDescribe().isAccessible())
            return true;
        else{
            return false;
        }
    }
    
    /*
     * The method which will actually copy data from one field to other.
     */
    public pagereference copydata(){
        Map <String, Schema.SObjectField> fieldMap = objectschemas.get(SelectedSObject).getDescribe().fields.getMap();
        
        //Building the query to fetch data.
        String query='select '+String.escapeSingleQuotes(tofield)+', '+String.escapeSingleQuotes(fromfield)+' from '+String.escapeSingleQuotes(SelectedSObject);
        
        if(!(isSafeField(fromField,SelectedSObject) && isSafeField(toField,SelectedSObject) && isSafeObject(SelectedSObject))){
            apexPages.addmessage(new apexpages.message(apexpages.severity.error,'Inaccessible Field or object'));
        }else if(fieldmap.get(fromField).getdescribe().gettype()!=fieldmap.get(toField).getdescribe().gettype()){
            apexpages.addmessage(new apexpages.message(apexpages.severity.error,'Fields Must Be of Same Data Type'));
        }else if(tofield==fromfield){
            apexpages.addmessage(new apexpages.message(apexpages.severity.error,'Fields Must Be Different'));
        }else{
            try{
                list<sObject> copylist=Database.query(query);
                
                //Copy the data of from field to, to field
                for(sobject copy: copylist){
                    copy.put(tofield,copy.get(fromfield));
                    dataTyp = string.valueOf(copy.getSObjectType());
                }
                
                Boolean isUpdateableSObject = Schema.getGlobalDescribe().get(selectedSobject).getDescribe().isUpdateable();
                
                if(isUpdateableSObject && isSafeObject(selectedSobject))
                    update copylist;
                    
                apexpages.addmessage(new apexpages.message(apexpages.severity.confirm,'Fields Successfully Updated'));
            }catch(exception e){
                apexpages.addmessage(new apexpages.message(apexpages.severity.error,e.getmessage()));
            }
        }
        return null;
    }
}
