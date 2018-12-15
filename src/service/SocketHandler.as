package service {

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.Socket;
import flash.net.URLLoader;
import flash.net.URLRequest;

public class SocketHandler {

    internal var clientSocket:Socket;

    internal var path:String = "../assets/net-config.xml";

    internal var url:URLRequest;
    internal var loader:URLLoader;
    internal var xml:XML;
    internal var isConnected:Boolean = false;

    public function SocketHandler() {
    }

    private function onLoaderComplete(event:Event):void {
        var result:URLLoader = URLLoader(event.target);
        xml = XML(result.data);
        do {
            try {
                clientSocket = new Socket(xml.ip, int(xml.port));
                clientSocket.addEventListener(IOErrorEvent.IO_ERROR,socketError);
                isConnected = true;
            } catch (err:Error) {
                isConnected = false;
                trace(err.toString())
            }
        } while (!isConnected) ;
        clientSocket.addEventListener(Event.CONNECT, onConnect);
        clientSocket.addEventListener(Event.CLOSE, socketClose)
    }

    private function socketClose(event:Event):void {
        trace(event.toString())
    }

    private function socketError(event:IOErrorEvent):void {
        trace(event.toString());
        connect();
    }

    public function connect():void {
        url = new URLRequest(path);
        loader = new URLLoader();
        loader.addEventListener(Event.COMPLETE, onLoaderComplete);
        loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
        loader.load(url);
    }

    private function onError(event:IOErrorEvent):void {
        trace(event.toString())
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

    public function close():void {
        if (clientSocket != null && clientSocket.connected) {
            clientSocket.close();
        }
    }
}
}
