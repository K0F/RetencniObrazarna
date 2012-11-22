
byte [] MAGIC_JPEG_BLOCK = {-1,-40,-1,-32,0,16,74,70,73,70};

class Chunk {
  ArrayList packets;
  byte raw[];
  InnerSession session;


  Chunk(InnerSession _session) {
    session = _session;
    packets = new ArrayList();
  }
  
  
  void sortByTime(){
   Collections.sort(packets, new TimeComparator()); 
  }
  
  
  void sortByAck(){
   Collections.sort(packets, new TimeComparator()); 
  }
  
  void dumpAll(){
    
    
    int counter = 0;
    for(int i = 0 ; i < packets.size();i++){
     InnerPacket p = (InnerPacket)packets.get(i);
     counter += p.data.length;
    }
    
    int offset = 0;
    InnerPacket first = (InnerPacket)packets.get(0);
    
    beginning:
    for(int i = 0 ; i < first.data.length - MAGIC_JPEG_BLOCK.length;i++){
      int checksum = 0;
      for(int m = 0; m < MAGIC_JPEG_BLOCK.length;m++){
        checksum += ((int)first.data[i+m]-(int)MAGIC_JPEG_BLOCK[m]);
      }
      if(checksum==0){
       offset = i;
       break beginning; 
      }
    }
    
    println(first.ack+" has offset @ "+offset);
    
     raw = new byte[counter-offset];
    
    
    // fill the first
    int c = 0 ;
    for(int ii = offset ; ii < first.data.length;ii++){
      raw[c] = first.data[ii];
      c++;
    }
    
    
   
    
    long number = 0;
    counter = 0;
    for(int i = 1 ; i < packets.size();i++){
     InnerPacket p = (InnerPacket)packets.get(i);
      for(int ii = 0 ; ii < p.data.length;ii++){
       number = p.ack;
       raw[counter] = p.data[ii];
       counter++;
      }
    }
    
    constructImage();
    
   // println("dumping "+packets.size()+" packets in one chunk");
    saveBytes("output/"+first.ack+".raw",raw);
    
  }
  
  void constructImage(){
    try{
    IMAGES.add(GetFromJPEG(raw));
    }catch(Exception e){;
    }
  }
}
