void getPhotosByLocation(float _lat, float _lon) {
  
  //azzero l'array
  photos.clear();
  
  String flickrUrl;

  if (hasTag ==false && hasCoordinates == true){
   //coordinate & miUploadDate
   flickrUrl = "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key="+apiKey+"&min_upload_date="+minUploadDate+"&sort=interestingness-desc&accuracy="+accuracy+"&lat="+_lat+"&lon="+_lon+"&extras=geo%2C+url_z%2C+owner_name&format=rest&per_page="+numPhotosPlaces;
   println("case1");
   }else if(hasTag == true && hasCoordinates == true){
   //coordinate & tag
   flickrUrl = "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key="+apiKey+"&tags="+tag+"&sort=interestingness-desc&accuracy="+accuracy+"&lat="+_lat+"&lon="+_lon+"&extras=geo%2C+url_z%2C+owner_name&format=rest&per_page="+numPhotosPlaces;  
   println("case2");  
   }else if(hasTag == true && hasCoordinates == false){
   //tag & minUploadDate
   flickrUrl = "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key="+apiKey+"&min_upload_date="+minUploadDate+"&tags="+tag+"&sort=interestingness-desc&accuracy="+accuracy+"&extras=geo%2C+url_z%2C+owner_name&format=rest&per_page="+numPhotosPlaces;   
   println("case3");
   }else {
   //minUploadDate & maxUploadDate
   flickrUrl = "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key="+apiKey+"&min_upload_date="+minUploadDate+"&max_upload_date="+maxUploadDate+"&sort=interestingness-desc&accuracy="+accuracy+"&extras=geo%2C+url_z%2C+owner_name&format=rest&per_page="+numPhotosPlaces;
   println("case4");
  }
  
  
  XMLElement xml = new XMLElement(this, flickrUrl); //creo un elemento xml per inserire il risultato della query
  String[] errCodes = getStatus(xml);  //Pull error codes (if any) from the XML
  if (errCodes[0].equals("ok")) {  
     
    XMLElement root = xml.getChild(0);
     
     //per ogni foto nell'array prende le informazioni necessarie e le inserisce nell'elemento Photo che verrà inserito nell'arrayList photos
     int childCount = root.getChildCount();
     for (int i=0; i < childCount; i++) {
        String id = root.getChild(i).getStringAttribute("id");
        String owner = root.getChild(i).getStringAttribute("ownername");
        String title = root.getChild(i).getStringAttribute("title");
        String url_z = root.getChild(i).getStringAttribute("url_z");
        
        photos.add( new Photo(id, title, owner, url_z));

        println(url_z);
     }
  } else {
    println ("Error! Here are some codes:\n" + errCodes); //stampa codice e messaggio dell'errore nel caso ci siano errori
  }
}

//Guarda l'attributo stat dell'XML ritornato dalla query e mi restituisce un array con tre stringhe: se il valore della prima è "ok", tutto bene, 
//altrimenti se è "fail", inserisce nelle altre due stringhe il codice e il messaggio dell'errore
String[] getStatus(XMLElement xml) {
  String[] retVal = {"","",""};
  retVal[0] = xml.getStringAttribute("stat");
  if (retVal[0].equals("fail")) {
     retVal[1] = xml.getChild(0).getStringAttribute("code");
     retVal[2] = xml.getChild(0).getStringAttribute("msg");
  }
  return retVal;
  
}
