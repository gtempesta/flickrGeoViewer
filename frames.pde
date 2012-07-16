void nextFrame(){  
    //ad ogni nuova foto le impostazioni di pan e zoom vengono azzerate
    resetPanAndZoom();
    totFrame = 0; // si azzera il counter per il tempo di zoom e pan
    photosDisplayed +=1; // incremento
    photosDisplayed =  photosDisplayed %photos.size(); // per poter tornare alla prima foto una volta arrivati all'ultima
    
    //prendo la foto all'indice incrementato
    Photo p = (Photo) photos.get(photosDisplayed);
    buf = loadImage(p.url); //carica la foto
    dimX = (buf.width*2)/3; //diminuisco le dimensioni dell'immagine in modo che quando lo zoom sia completato la qualità sia ancora buona
    dimY = (buf.height*2)/3;
    
    println(p.url);

  
}

void previousFrame(){  
    resetPanAndZoom();
    totFrame = 0;
    photosDisplayed -=1;
    photosDisplayed =  (photosDisplayed+photos.size()) %photos.size(); //per evitare che il valore sia negativo
    
    Photo p = (Photo) photos.get(photosDisplayed);
    buf = loadImage(p.url);
    dimX = (buf.width*2)/3; //diminuisco le dimensioni dell'immagine in modo che quando lo zoom sia completato la qualità sia ancora buona
    dimY = (buf.height*2)/3;
    
    println(p.url);


}
