 void displayImage(){
   
  if(!noPhotos){
    
    //pesco dall'arrayList che ho creato tutte la foto all'indice presente
    Photo p = (Photo) photos.get(photosDisplayed);
    
    if (hidePhotos == false){
    //display image
    pushMatrix();
    scale(zoom);
    image(buf, posX, posY, dimX, dimY);
    popMatrix();
    
     //dimensioni dell'immagine per poter fare lo zoom
     if(mouseX > posX*zoom - (dimX*zoom/2) && mouseX < posX*zoom + (dimX*zoom/2) && mouseY > posY*zoom - (dimY*zoom/2) && mouseY < posY*zoom + (dimY*zoom/2) && totFrame>framesToDisplay && !lockedW){
      bover = true;
      wheelOk = false;
      dragMap = false;
     }else{
      bover = false;
      wheelOk = true;
      dragMap = true;
     }
     
    }  

    
    //i due rettangoli in basso e in alto
    fill(0);
    rect(0, 560, width, height - 560);
    fill(40);
    rect(0, 0, width, 150);
   
    
    //rettangolo e scritta con titolo e autore
    fill(204);
    stroke(204);
    rect(0,540,width, 20);
    
    fill(0);
    textAlign(CENTER);
    text(p.title + " by " + p.owner, txtX, txtY);

    //muovo il testo per leggerlo tutto, nel caso nonci stia tutto
    if(mouseX > 0 && mouseX < width && mouseY > 540 && mouseY < 560){
      lockedW = true;
    }else{
      lockedW = false;
    }
   
    
    fill(248);
    text(photosDisplayed + 1 +"/"+photos.size(), width/2, 592);
    
    //un counter oltre al quale si bloccano zoom e pan
    totFrame +=1;
    if(totFrame<framesToDisplay){
    zoom *= zoomFactor;
    posX += panX;
    posY += panY;
    }
    
  }else{
     //se la ricerca non ha prodotto risultati troviamo questa scritta
     background(0);
     fill(255);
     textAlign(CENTER);
     text("Your search didn't get any result: try again!", width/2, height/2); 
  }
  
  
}

