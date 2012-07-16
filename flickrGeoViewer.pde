//per gestire i controller
import controlP5.*;

ControlP5 controlP5;

//Per gestire la mappa
InteractiveMap map;
Location locMap;

PFont font;

//per le chiamate alla API di flickr
String apiKey = "47e60b8f658919e68b5683b8f0491c0b";
String sharedSecret = "2dc612bddaeb663c";

//per le chiamate alla API di GoogleMaps (coordinate da indirizzo)
String gAPI_KEY = "ABQIAAAATLZP-hcovKmhzPBNXslrXxSHeWmh27kGzClPxfxgE5ga-Dq81BSPC1Z2NMy0lEc0Zu1pVEQlT1Yb9A";

//serviranno??
boolean zoomingIn = false;
float easing = 2.1;

//se non ci sono foto non viene creato l'arrayList e compare un messaggio di errore
boolean noPhotos = false;

boolean hidePhotos = false;

boolean hasCoordinates = true;
boolean hasTag = false;
boolean hasPrecision = true;

//quando è vero comincia a mostrare le foto
boolean searching = false;

//Variabili per la chiamata a flickr
int minUploadDate = 1262325600;
int maxUploadDate = 1293861600;
int accuracy = 13;
float lat = 40.76;
float lon = -73.97;
String tag;
int numPhotosPlaces = 20;

//dove saranno messe le foto restituite dalla query
ArrayList photos;  
int photosDisplayed = 0; //indice nell'arrayList

//la posizione del testo con le descrizioni
float txtX;
float txtY;

//mostrare l'immagine e variabili per drag
PImage buf;
float posX = 0;
float posY = 0;
float iDifx = 0.0; //differenza tra posizione attuale e passata
float iDify = 0.0; 
int dimX; //dimensioni immagine
int dimY; 
boolean bover = false;
boolean locked = false;

boolean overW = false;
boolean lockedW = false;
float difTextX = 0.0;

boolean wheelOk = true;
boolean dragMap = true;

//Per fare in modo che passato un certo tempo i movimenti si arrestino
int totFrame = 0;
int FPS = 30;
int framesToDisplay = (int) (FPS * 3);

//Pan e Zoom
float panX, panY; // di qnt si sposta l'immagine
float panSpeed = 1.0;  //velocità 
float zoom = 1;  //zoom attuale
float zoomFactor = 1.005;  //incremento dello zoom

void setup(){
  
    // set a default font for labels
 font = createFont("STHeiti", 16);
 
  txtX = width/2;
  txtY = 555;
  
  size(480, 650);
  
  //controller
  controlP5 = new ControlP5(this);
  controlP5.addButton("search", 30, 30, 20, 60, 19);
  controlP5.addButton("clear", 30, width - 128, 20, 38, 19);
  controlP5.addButton(" + ", 20, width/2 + 80 - 21, 610, 21, 21); //zoom
  controlP5.addButton(" - ", 20, width/2 - 80, 610, 21, 21); 
  controlP5.addTextfield("coordinates",30,60,120,20); 
  controlP5.addTextfield("tag",30,100,120,20);
  controlP5.addTextfield("address",190,60,120,20);
  controlP5.addTextfield("precision",190,100,120,20);
  controlP5.addButton("   <   ", 40, (width/2) - 200, 580, 40, 19);
  controlP5.addButton("   >   ", 40, (width/2) + 200 - 40, 580, 40, 19); 
  controlP5.addToggle("hide photos",false,190,20,19,19);
  
  
  photos = new ArrayList();

  imageMode(CENTER);
  smooth();
  
  map = new InteractiveMap(this, new Microsoft.RoadProvider());
  map.setCenterZoom(new Location(lat, lon), 14);    
  // zoom 0 is the whole world, 19 is street level
  
    // enable the mouse wheel, for zooming
  addMouseWheelListener(new java.awt.event.MouseWheelListener() { 
    public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) { 
      mouseWheel(evt.getWheelRotation());
    }
  }
  );

}

void draw(){ 
   background(100);
   map.draw(); //mappa sullo sfondo
    
  fill(0);
  rect(0, 560, width, height - 560); //rettangolo nero in basso
  fill(40);
  rect(0, 0, width, 150); //rettangolo grigio in alto
  
  if(searching){ 
    //una volta impostata la ricerca vengono mostrate le foto
     displayImage(); 
  }
  
  
  //info su coordinate, tag e precisione nella ricerca
  textAlign(LEFT);
  fill(255);
  
  textFont(font, 14);
  if(hasCoordinates == true){
  text("latitude: "+lat, width - 128, 76);
  text("longitude: "+lon, width - 128, 96);
  }else{
  text("latitude: - ", width - 128, 76);
  text("longitude: - ", width - 128, 96);
  } 
  if(hasTag == true){
  text("tag: " + tag, width - 128, 116);
  }else{
  text("tag: -", width - 128, 116);
  }
  text("precision: "+accuracy, width - 128, 136);
  
  //rettangolo e scritta con coordinate della mappa
  fill(204);
  stroke(204);
  rect(0,150,width, 20);
  fill(0);
  text("Map Coordinates: " + locMap, 10, 164);
  
  fill(255);
  textAlign(CENTER);
  text("zoom photos", width/2 , 628);
  
  if(!searching){
  fill(248);
  text("0/0", width/2, 592);
  }
  
   // mappa al centro
  locMap = map.pointLocation(width/2, height/2);
}

//azione eseguita dal pulsante search ! !
public void search() {
  noPhotos = false;
  totFrame = 0;
  photosDisplayed = 0;
  getPhotosByLocation(lat, lon);

  loadTheImage();
  resetPanAndZoom();
  searching = true;
  
}


//funioni attivate dai vari controller
public void controlEvent(ControlEvent theEvent) {
  if (theEvent.controller().name() == "   >   ") {
    //immagine seguente
    nextFrame();
    println(theEvent.controller().name());
    println("forth");
  
    }else if (theEvent.controller().name() == "   <   ") {
    //immagine precedente
    previousFrame();
    println(theEvent.controller().name());
    println("back");
  
    }else if(theEvent.controller().name() == " + "){
    //zoomIn
    zoom *= (zoomFactor + 0.02);
    zoomingIn = true;
    
    }else if(theEvent.controller().name() == " - "){
    //zoomOut
    zoom /= (zoomFactor + 0.02);
    zoomingIn = false;
    
    }else if(theEvent.controller().name() == "hide photos"){
      if (hidePhotos == true){
      hidePhotos = false;
      }else{
      hidePhotos = true;
      bover = false;
      }
    
    }else if(theEvent.controller().name() == "clear"){
      hasTag = false;
      hasCoordinates = false;
    }else if (theEvent.controller().name() == "coordinates"){
      hasCoordinates = true;
      searching = false; //le immagini non vengono più mostrate
      totFrame = 0;   // se i frames si azzerano posso muovere di nuovo la mapp
      
      //le coordinate, separate da virgola e spazio, vengono divise in due valori
      String input = theEvent.controller().stringValue();
      String[] coords = splitTokens(input, ", ");
      //è la stessa variabile che poi verrà stampata sullo schermo
      lat = float(coords[0]);
      lon = float(coords[1]);
      //la posizione della mappa viene aggiornare in base alle coordinate
      map.setCenterZoom(new Location(lat, lon), 15);
      
    }else if(theEvent.controller().name() == "tag"){
      
      hasTag = true;
      searching = false; //immagini non più mostrate
      bover = false; //in modo da tornare a muovere la mappa
      totFrame = 0;   
      
      //si inserisce un valore nel campo tag
      tag = theEvent.controller().stringValue();
  
    }else if (theEvent.controller().name() == "precision"){
      
      hasPrecision = true;
      searching = false; //immagini non più mostrate
      bover = false;
      totFrame = 0;  
      
      //modifica il valore di accuracy
      String a = theEvent.controller().stringValue();
      accuracy = Integer.parseInt(a);
      println(accuracy);
      
    }else if(theEvent.controller().name() == "address"){
      
      hasCoordinates = true;
  
      searching = false;  
      bover = false;
      totFrame = 0; 
      
      //creo una query per la API di GoogleMaps in cui inserisco il luogo 
      String location = theEvent.controller().stringValue();
      String locationEncoded = URLEncoder.encode(location);
      String url = "http://maps.google.com/maps/geo?q="+locationEncoded + "&output=xml&key=" + gAPI_KEY;
      XMLElement gXml = new XMLElement(this, url);

      //All'interno dell'XML è presente l'inidirizzo che interpreta
      XMLElement addressElement = gXml.getChild("Response/Placemark/address");
      if(addressElement != null){
        //se questo elemento esiste lo stampo
        String addressStr = addressElement.getContent( );
        println("Address: " + addressStr);
      
        //poi posso ottenere le coordinate 
        XMLElement coordsElement = gXml.getChild("Response/Placemark/Point/coordinates");
        String coordsStr = coordsElement.getContent( );
        String[] coords = split(coordsStr, ',');
        lon = truncate(float(coords[0]));
        lat = truncate(float(coords[1]));
        println("Longitude: " + lon);
        println("Latitude: " + lat);
        //centro la mappa sui nuovi valori
        map.setCenterZoom(new Location(lat, lon), 15);
        }else{
        println("wrong address!");
        }
      }

}
 
 
 // zoom in or out:
void mouseWheel(int delta) {
  if (delta < 0) {
    map.sc *= 1.1;
  }else if (delta > 0) {
    map.sc *= 1.0/1.1; 
  }
} 


//6. spiegazione in basso (coordinate separate da virgola e spazio, una sola tag)
//7. relazione


//coordinates must be separated with ", "
//precision is a value from 0 to 16, the highest the value, the closest are the photos to the coordinates
//remember to press "enter" to insert each value
