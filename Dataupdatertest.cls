/**
    * Webkul Software.
    *
    * @category  Webkul
    * @author    Webkul
    * @copyright Copyright (c) 2010-2016 Webkul Software Private Limited (https://webkul.com)
    * @license   https://store.webkul.com/license.html
    */
@istest 
public class Dataupdatertest{
    @istest
    static void testmethod1(){
      Dataupdater obje = new Dataupdater();
      obje.SelectedSObject='contact';
      obje.fromField='firstname';
      obje.toField='lastname';
    
      
      system.assertnotequals(obje.getSObjectList(),null); 
      
      system.assertequals(obje.showFields(),null); 

      system.assertnotequals(obje.getFieldsofobject(),null);
 
      system.assertequals(obje.copydata(),null); 

    }
}
