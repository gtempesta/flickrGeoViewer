//funzioni per attivare il drag

void mousePressed() {
  
  if (bover) {
    locked = true;
    iDifx = mouseX-posX; 
    iDify = mouseY-posY; 
    cursor(HAND);
    }else{
    locked = false;
  }
}

void mouseDragged (){
  if (locked){
    posX = (mouseX - iDifx);
    posY = (mouseY - iDify);
    }else if(mouseY > 150 && mouseY < 540 && dragMap){
    map.mouseDragged();
    }else if(mouseX > 0 && mouseX < width && mouseY > 540 && mouseY < 560 && searching){
          cursor(HAND);
          if(mouseX > pmouseX && txtX<width){
          txtX = txtX + 2 + (mouseX - pmouseX);
        }else if (mouseX < pmouseX && txtX>0){
          txtX = txtX - 2 - (pmouseX - mouseX);
        }
    }
  }


void mouseReleased() {
  locked = false;
  lockedW = false;
  cursor(ARROW);
}

