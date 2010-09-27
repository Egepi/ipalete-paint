/**************************************************
 * Used to create threads.
 * NOTE: Threads currently not working in linux so
 *       this features isn't currently being used.
 */
Thread thread;
class BasicThread implements Runnable 
{
  // This method is called when the thread runs
  public void run() 
  {
    connectClient();          
  }
}


