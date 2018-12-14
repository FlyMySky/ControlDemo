package service {

import flash.events.Event;
import flash.net.Socket;
import flash.net.URLLoader;
import flash.net.URLRequest;

public class SocketHandler {

    internal var clientSocket:Socket;

    internal var path:String = "../assets/net-config.xml";

    internal var url:URLRequest;
    internal var loader:URLLoader;
    internal var xml:XML;

    public function SocketHandler() {
    }

    private function onLoaderComplete(event:Event):void {
        var result:URLLoader = URLLoader(event.target);
        xml = XML(result.data);
        clientSocket = new Socket(xml.ip, xml.port);
        clientSocket.addEventListener(Event.CONNECT, onConnect)
    }

    public function connect():void {
        url = new URLRequest(path);
        loader = new URLLoader();
        loader.addEventListener(Event.COMPLETE, onLoaderComplete);
        loader.load(url);
    }

    private function onConnect(event:Event):void {
        trace("remoteAddress:" + clientSocket.remoteAddress + "   remotePort:" + clientSocket.remotePort)
    }

    public function sendMsg(msg:String):void {
        if (clientSocket != null && clientSocket.connected) {
            clientSocket.writeUTFBytes(msg);
            clientSocket.flush();
        }
    }

}
}
