//
// Copyright (c) 2016 eBay Software Foundation
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit
import NMessenger
import AsyncDisplayKit
import Alamofire
import SwiftyJSON
// not needed in your implementation


class ChatViewController: NMessengerViewController {
    
    private(set) var lastMessageGroup:MessageGroup? = nil
    var image :ASDisplayNode? = nil
   //E h:mm a
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E h:mm a"
        return formatter
    }()
    
    
    fileprivate let formatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

    //This is not needed in your implementation. This just for a demo purpose.
    var bootstrapWithRandomMessages : Int = 0
    var idSender:String = "19"
    
    
    func addMessageNode(meta:[JSON]) {
        
        
        meta.forEach{ data in
            
            var isIncomingMessage = true
            
            
            let messageTimestamp = MessageSentIndicator()
            let date = formatter2.date(from: data["date"].stringValue)
            let finalDate=formatter.string(from: date!)
            messageTimestamp.messageSentText = finalDate
            
            
            let textContent = TextContentNode(textMessageString:data["text"].stringValue, currentViewController: self, bubbleConfiguration: self.sharedBubbleConfiguration)
            let newMessage = MessageNode(content: textContent)
            
            
            
            newMessage.cellPadding = self.messagePadding
            newMessage.currentViewController = self
            newMessage.isIncomingMessage=isIncomingMessage
            if(isIncomingMessage){
                //messageGroup.avatarNode = image
                
                newMessage.avatarNode=self.image
                lastSenderMessageId=data["id_message"].stringValue
            }
            self.messengerView.addMessage(messageTimestamp, scrollsToMessage: false)
            self.messengerView.addMessage(newMessage, scrollsToMessage: true, withAnimation: .left)
        }
    }

    
    
    func setupMessageNode(meta:JSON) {
        let user1 = meta["user1"]
        let user2 = meta["user2"]
        
        
        var imageUrl = user1["photo"].stringValue
        if(AppDelegate.userId==user2["id"].stringValue){
            imageUrl = user2["photo"].stringValue
        }
        
        if(self.image == nil){
            
        
        self.image = self.createAvatar(url: AppDelegate.serverImage+imageUrl)
        }
         meta["messages"].arrayValue.forEach{ data in

        var isIncomingMessage = false
        let id = data["sender"].stringValue
            
            
        if(id != AppDelegate.userId){
            isIncomingMessage=true
           
            
        }
       
            
            let messageTimestamp = MessageSentIndicator()
            let m = data["date"].stringValue
            
            let date = formatter2.date(from: data["date"].stringValue)
            if(date == nil){
            messageTimestamp.messageSentText = "error"
            }
            else {
                let finalDate=formatter.string(from: date!)
                messageTimestamp.messageSentText = finalDate
            }
            
            
            
        let textContent = TextContentNode(textMessageString:data["text"].stringValue, currentViewController: self, bubbleConfiguration: self.sharedBubbleConfiguration)
        let newMessage = MessageNode(content: textContent)
            
           
            
            newMessage.cellPadding = self.messagePadding
        newMessage.currentViewController = self
              newMessage.isIncomingMessage=isIncomingMessage
            if(isIncomingMessage){
                //messageGroup.avatarNode = image
                
                newMessage.avatarNode=self.image
                lastSenderMessageId=data["id_message"].stringValue
            }
           messages.append(messageTimestamp)
            messages.append(newMessage)
           
        }
    }
    var lastSenderMessageId:String=""
   
     var messageGroups = [MessageGroup]()
    var messages = [GeneralMessengerCell]()
    var isFetching=false
    func execute(){
        if(isFetching){
            
            self.getMessages(idSender: idSender, idReceiver: AppDelegate.userId,idMessage: self.lastSenderMessageId)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      //  navigationItem.titleView = senderSegmentedControl
        
        //BEGIN BOOTSTRAPPING MESSAGES
       
        
       
        //END BOOTSTRAPPING OF MESSAGES
        var timer = Timer.scheduledTimer(timeInterval: 5, target: self,selector: "execute", userInfo: nil, repeats: true)
        
        getConversation(idSender: "5", idReceiver: "19")
        
    }

    override func sendText(_ text: String, isIncomingMessage: Bool) -> GeneralMessengerCell {
        
        //create a new text message
        let textContent = TextContentNode(textMessageString: text, currentViewController: self, bubbleConfiguration: self.sharedBubbleConfiguration)
        let newMessage = MessageNode(content: textContent)
        newMessage.cellPadding = messagePadding
        newMessage.currentViewController = self
        newMessage.isIncomingMessage=isIncomingMessage
        sendMessage(idSender: AppDelegate.userId, idReceiver: self.idSender, text: text)
        self.postText(newMessage, isIncomingMessage: isIncomingMessage)
        return newMessage
    }
    
    //MARK: Helper Functions
    /**
     Posts a text to the correct message group. Creates a new message group *isIncomingMessage* is different than the last message group.
     - parameter message: The message to add
     - parameter isIncomingMessage: If the message is incoming or outgoing.
     */
    private func postText(_ message: MessageNode, isIncomingMessage: Bool) {
        
    self.messengerView.addMessage(message, scrollsToMessage: true, withAnimation: isIncomingMessage ? .left : .right)
    
    
    }
    

    
    
    func sendMessage(idSender:String,idReceiver:String,text:String)   {
        Alamofire.request(AppDelegate.serverUrl+"sendMessage", method: .post,parameters: ["id_sender": idSender,"id_receiver":idReceiver,"message":text ])
            
            .responseJSON { response in
                //      print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    //self.users = data["users"].arrayValue
                    //self.table.reloadData()
                    
                    let info = data["error"].boolValue
                    if(info){
                    print("eroor")
                        
                    }
                    else {
                   print("done")
                    }
                    
                    
                    
                }
                
                
        }
        
        
    }
    

    
    
    func getConversation(idSender:String,idReceiver:String)   {
        Alamofire.request(AppDelegate.serverUrl+"getConversation", method: .post,parameters: ["id_sender": idSender,"id_receiver":idReceiver ])
            
            .responseJSON { response in
                //      print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    //self.users = data["users"].arrayValue
                    //self.table.reloadData()
                    
                    let info = data["data"]
                    
                   
                    
                        self.setupMessageNode(meta: info)
                       
                        
                        
                    
                    self.automaticallyAdjustsScrollViewInsets = false
                   // self.lastMessageGroup = self.messageGroups.last
                    self.messengerView.addMessages(self.messages, scrollsToMessage: true)
                    self.isFetching=true
                    
                  //  self.messengerView.addMessages(self.messageGroups, scrollsToMessage: false)
                    
                   // self.messengerView.scrollToLastMessage(animated: true)
                    
                    
                    
                }
                
                
        }
        
        
    }

    
    func getMessages(idSender:String,idReceiver:String,idMessage:String)   {
        Alamofire.request(AppDelegate.serverUrl+"getMessage", method: .post,parameters: ["id_sender": idSender,"id_receiver":idReceiver,"id_message":idMessage ])
            
            .responseJSON { response in
                //      print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    //self.users = data["users"].arrayValue
                    //self.table.reloadData()
                    
                    let info = data["error"].boolValue
                    if(!info){
                        let messages = data["messages"].arrayValue
                        print ("messages:"+String(describing: messages.count))
                        self.addMessageNode(meta: messages)
                        return
                    }
                    
                    print ("no update")
                    
                    
                    
                    
                    
                    
                    
                }
                
                
        }
        
        
    }

    
    
    /** 
     Creates a new message group for *lastMessageGroup*
     -returns: MessageGroup
     */
    private func createMessageGroup()->MessageGroup {
        let newMessageGroup = MessageGroup()
        newMessageGroup.currentViewController = self
        newMessageGroup.cellPadding = self.messagePadding
        return newMessageGroup
    }
    
    /**
     Creates mock avatar with an AsyncDisplaykit *ASImageNode*.
     - returns: ASImageNode
     */
    private func createAvatar(url:String)->ASDisplayNode {
       
    
        let imageNode = ASNetworkImageNode()
        imageNode.url = URL(string: url)
        imageNode.style.preferredSize = CGSize(width: 40, height: 40)
        imageNode.layer.cornerRadius = 10
        
        return imageNode
        
        /*
        let avatar = ASImageNode()
        avatar.backgroundColor = UIColor.lightGray
        avatar.style.preferredSize = CGSize(width: 20, height: 20)
        avatar.layer.cornerRadius = 10
        return avatar
 */
    }
    
    /**
     Just a helper to give a random isIncomingValue
    */
    func randomBool() -> Bool {
        return arc4random_uniform(2) == 0
    }
    
    deinit {
        print("Deinitialized")
    }
    
    
    override
    func getInputBar() -> InputBarView {
        let input = CustumBarView(controller: self)
        return input
    }
    
}

