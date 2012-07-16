//una volta ottenute le immagini esse vengono caricate
void loadTheImage(){

  if (photos.size() != 0){
    //si parte con la prima immagine della ricerca, per vedere le altre ci sono i tasti < e >
    Photo p = (Photo) photos.get(0);
    buf = loadImage(p.url);
    dimX = (buf.width*2)/3; //diminuisco le dimensioni dell'immagine in modo che quando lo zoom sia completato la qualità sia ancora buona
    dimY = (buf.height*2)/3;
    }else{
    noPhotos = true; //se non ci sono foto questo booleano fa in modo di non mostrare le immagini e di far vedere un messaggio di errore
  }

}

// Resets all the pan and zoom information to a new random direction
void resetPanAndZoom() {

  posX = width/2;
  posY = height/2;
  
  // Nuova direzione per il pan
  float angle = radians(random(-5,5));
  float direction = 1.0;
  if (random(10) > 5) {
    direction = -1.0;
  }
  
  //do un leggero movimento di pan
  panX = panSpeed * -1.0 * cos(angle);
  panY = panSpeed * -1.0 * cos(angle);
  
  //reset zoom
  zoom = 1.0;
  //posiziono il testo
  txtX = (width/2) - 40;

}

//funzione per riportare a due zeri dopo la virgola i valori ritornati dalla query di googleMaps
float truncate(float x){
 if ( x > 0 )
   return float(floor(x * 100))/100;
 else
   return float(ceil(x * 100))/100;
}
