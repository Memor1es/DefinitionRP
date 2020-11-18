$(document).ready(function(){
  // Mouse Controls
  var documentWidth = document.documentElement.clientWidth;
  var documentHeight = document.documentElement.clientHeight;
  var cursor = $('#cursor');
  var cursorX = documentWidth / 2;
  var cursorY = documentHeight / 2;
  var lstMsgs = [];
  var lstnotifications = [];
  var lstnotificationsYP = [];
  var lstMsgsRead = [];
  var contactList = [];
  var alertList = [];
  var appList = [];
  var galList = [];
  var canShowAlerts = false;
  var gurgling = false;
  var twatting = false;
  var curtwats = [];
  var GPS = false;
  var contacting = false;
  var fondopantalla = 'nui://betrayed_phone/html/fondo.jpg';


  function UpdateCursorPos() {
      $('#cursor').css('left', cursorX+2);
      $('#cursor').css('top', cursorY+2);
  }

  var id1 = 1
  var id2 = 1
  var entityMap = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#39;',
    '/': '&#x2F;',
    '`': '&#x60;',
    '=': '&#x3D;'
  };

  function escapeHtml (string) {
    return String(string).replace(/[&<>"'`=\/]/g, function (s) {
      return entityMap[s];
    });
  }

  function triggerClick(x, y) {
      var element = $(document.elementFromPoint(x, y));
      element.focus().click();
      return true;
  }


  function openBrowser()
  {
    closeAll()
    $(".phone-container").fadeOut(850);
    $("#cursor").css("display", "none");
    $(".full-screen").fadeOut(100);
    $(".home").fadeOut(100);
    $(".browser").fadeIn(10);
  }

  function openBrowser2()
  {
    closeAll()
    $(".phone-container").fadeOut(850);
    $("#cursor").css("display", "none");
    $(".full-screen").fadeOut(100);
    $(".home").fadeOut(100);
    $(".browser2").fadeIn(10);
  }

  function openBrowser3()
  {
    closeAll()
    $(".phone-container").fadeOut(850);
    $("#cursor").css("display", "none");
    $(".full-screen").fadeOut(100);
    $(".home").fadeOut(100);
    $(".browser3").fadeIn(10);
  }
  
  function openFotoEnorme(foto,clase)
  {
	$(".fotoenorme").empty();
	var element = $('<img class="browserin" src="'+ foto +'">')
	element.click(function(){  
      $.post('http://betrayed_phone/cerrarfoto', JSON.stringify({id: foto, chat: clase,})); 
    });
    closeAll();
    $(".phone-container").fadeOut(850);
    $(".full-screen").fadeOut(100);
    $(".home").fadeOut(100);
	$(".fotoenorme").append(element);
    $(".fotoenorme").fadeIn(10);
  }


  // Partial Functions
  function closeMain() {
    $(".home").fadeOut(850);
    $(".browser").fadeOut(10);
	$(".fotoenorme").fadeOut(10);
    $(".browser2").fadeOut(10);
    $(".browser3").fadeOut(10);
  }

  var i = 20;                     //  set your counter to 1

  function openPhoneCSS () {           //  create a loop function
     setTimeout(function () {    //  call a 3s setTimeout when the loop is called
        $(".full-screen").css("margin-top", "" + i + "%");

        i = i - 0.25;                   //  increment the counter
        if (i > 0) {            //  if the counter < 10, call the loop function
           openPhoneCSS();             //  ..  again which will trigger another 
        }                        //  ..  setTimeout()
     }, 1)
  }


  function closePhoneCSS () {           //  create a loop function
     setTimeout(function () {    //  call a 3s setTimeout when the loop is called
        $(".full-screen").css("margin-top", "" + i + "%");
        i = i + 0.25;                     //  increment the counter
        if (i < 45) {            //  if the counter < 10, call the loop function
           closePhoneCSS();             //  ..  again which will trigger another 
        }                        //  ..  setTimeout()
     }, 1)
  }


  function openHome() {
    closeAll()
    $(".full-screen").fadeIn(100);
    $(".home").fadeIn(100);

    $("#phone-c").css("background-image", 'url("nui://betrayed_phone/html/background.png"),url('+ fondopantalla +')');

    document.getElementById("nukeDiv").innerHTML = "";

    var element = $("<div class='googleResult btnBox1'><div id='keywords' style='display:none;'>weed</div><a href='#' class='googleLink btnGoogleCar'>The Weed Man!</a><div class='description'>Click me to buy 1 Box Now ($1500)!</div></div>");  
    element.id = 1;  
    element.click(function(){  
      $.post('http://betrayed_phone/btnBox1', JSON.stringify({}));  
    });  

    $("#nukeDiv").prepend(element);
    var element = $("<div class='googleResult btnBox2'><div id='keywords' style='display:none;'>weed</div><a href='#' class='googleLink btnGoogleCar'>The Weed Man!</a><div class='description'>Click me to buy 5 Box Now ($4500)!</div></div>");  
    element.id = 2;  
    element.click(function(){  
      $.post('http://betrayed_phone/btnBox2', JSON.stringify({}));  
    });  

    $("#nukeDiv").prepend(element);
    var element = $("<div class='googleResult btnBox3'><div id='keywords' style='display:none;'>weed</div><a href='#' class='googleLink btnGoogleCar'>The Weed Man!</a><div class='description'>Click me to buy 10 Box Now ($8500)!</div></div>");  
    element.id = 3;  
    element.click(function(){  
      $.post('http://betrayed_phone/btnBox3', JSON.stringify({}));  
    });  
    $("#nukeDiv").prepend(element);



    var element = $("<div class='googleResult btnBox4'><div id='keywords' style='display:none;'>weed</div><a href='#' class='googleLink btnGoogleCar'>The Wizard!</a><div class='description'>Click me to buy a Class 2 Weapon!</div></div>");  
    element.id = 4;  
    element.click(function(){  
      $.post('http://betrayed_phone/btnBox4', JSON.stringify({}));  
    });  
    $("#nukeDiv").prepend(element);
    var element = $("<div class='googleResult btnBox5'><div id='keywords' style='display:none;'>weed</div><a href='#' class='googleLink btnGoogleCar'>The Wizard!</a><div class='description'>Click me to buy Lots of Crack!</div></div>");  
    element.id = 5;  
    element.click(function(){  
      $.post('http://betrayed_phone/btnBox5', JSON.stringify({}));  
    }); 
    $("#nukeDiv").prepend(element);


    $(".btnAlerts").css("display", "block");

  }

  function disableEmails() {
    $(".encrypted").css("display", "none");
  }

  function enableEmails() {
    $(".encrypted").css("display", "block");
  }

  function disableDecrypt() {
    $(".decrypt").css("display", "none");
  }

  function enableDecrypt() {
    $(".decrypt").css("display", "block");
  }


  function disableDecrypt2() {
    $(".decrypt2").css("display", "none");
  }

  function enableDecrypt2() {
    $(".decrypt2").css("display", "block");
  }

    function disableTrucker() {
    $(".Trucker").css("display", "none");
  }

  function enableTrucker() {
    $(".Trucker").css("display", "block");
  }

  function openMain() {
    closeAll()
    $(".full-screen").fadeIn(100);
    $(".home").fadeIn(100);
    $(".newsms").fadeOut(100);
    $(".newemail").fadeOut(100);
    $(".newtweet").fadeOut(100);
    $(".phonealerts-container").fadeOut(10);
    i = 20;
    openPhoneCSS()
    $("#phone-c").css("background-image", 'url("nui://betrayed_phone/html/background.png"),url('+ fondopantalla +')');
    document.getElementById("nukeDiv").innerHTML = "";
    var element = $("<div class='googleResult btnBox1'><div id='keywords' style='display:none;'>weed</div><a href='#' class='googleLink btnGoogleCar'>The Weed Man!</a><div class='description'>Click me to buy 1 Box Now ($1100)!</div></div>");  
    element.id = 1;  
    element.click(function(){  
      $.post('http://betrayed_phone/btnBox1', JSON.stringify({}));  
    });  

    $("#nukeDiv").prepend(element);
    var element = $("<div class='googleResult btnBox2'><div id='keywords' style='display:none;'>weed</div><a href='#' class='googleLink btnGoogleCar'>The Weed Man!</a><div class='description'>Click me to buy 5 Box Now ($4300)!</div></div>");  
    element.id = 2;  
    element.click(function(){  
      $.post('http://betrayed_phone/btnBox2', JSON.stringify({}));  
    });  

    $("#nukeDiv").prepend(element);



    var element = $("<div class='googleResult btnBox3'><div id='keywords' style='display:none;'>weed</div><a href='#' class='googleLink btnGoogleCar'>The Weed Man!</a><div class='description'>Click me to buy 10 Box Now ($8500)!</div></div>");  
    element.id = 3;  
    element.click(function(){  
      $.post('http://betrayed_phone/btnBox3', JSON.stringify({}));  
    });  
    $("#nukeDiv").prepend(element);


    var element = $("<div class='googleResult btnBox4'><div id='keywords' style='display:none;'>weed</div><a href='#' class='googleLink btnGoogleCar'>The Wizard!</a><div class='description'>Click me to buy a Class 2 Weapon!</div></div>");  
    element.id = 4;  
    element.click(function(){  
      $.post('http://betrayed_phone/btnBox4', JSON.stringify({}));  
    });  
    $("#nukeDiv").prepend(element);
    
    var element = $("<div class='googleResult btnBox5'><div id='keywords' style='display:none;'>weed</div><a href='#' class='googleLink btnGoogleCar'>The Wizard!</a><div class='description'>Click me to buy Lots of Crack!</div></div>");  
    element.id = 5;  
    element.click(function(){  
      $.post('http://betrayed_phone/btnBox5', JSON.stringify({}));  
    }); 

    $("#nukeDiv").prepend(element);




    $(".btnAlerts").css("display", "block");
  }

  function closeAll() {
    gurgling = false
    twatting = false
    GPS = false
    contacting = false;
    $(".btnOutstanding").fadeOut(1);
    $(".twatter-container2").css("display", "none");
    $(".browser3").fadeOut(10);
    $(".browser2").fadeOut(10);
    $(".browser").fadeOut(10);
	$(".fotoenorme").fadeOut(10);
    $(".realestateOutstanding-container").fadeOut(50);
    $(".keys-container").fadeOut(50);
    $(".calls-container").fadeOut(50);
    $(".realestate-container").fadeOut(50);
	$(".config-container").fadeOut(50);
	$(".fotogrande-container").fadeOut(50);
	$(".galeria-container").fadeOut(50);
    $(".body").fadeOut(50);
    $(".GPS-container").fadeOut(50);
    $(".google-container").fadeOut(50);
    // Clear input boxes
    $("#message-text").val('');
    $(".stock-container").fadeOut(50);
    $(".gangtask-container").fadeOut(50);
    $(".account-container").fadeOut(50);
    $(".secondary-container").fadeOut(50);
    $(".home").fadeOut(50);
    $(".assistance-container").fadeOut(50);
    $(".notifications-container").fadeOut(50);
    $(".messages-container").fadeOut(50);
    $(".message-container").fadeOut(50);
    $(".newMessage-container").fadeOut(50);
    $(".contacts-container").fadeOut(50);
    $(".newContact-container").fadeOut(50);
    $(".alerts-container").fadeOut(50);
	 $(".appstore-container").fadeOut(50);
    $(".twatter-container").fadeOut(50);
    $(".group-container").fadeOut(50);
    $(".GroupManager-container").fadeOut(50);
    $(".error-container").fadeOut(50);

    $(".popup-container").fadeOut(50);

    $("#newMessage-form #number").val('');
    $("#newMessage-form #message").val('');

    $("#newContact-form #name").val('');
    $("#newContact-form #number").val('');
    $("#phone-c").css("background-image", 'url("nui://betrayed_phone/html/backgroundwhite.png")');
  }
  function openContainer() {
    
    
    $(".phone-container").fadeIn(150);
    $("#cursor").css("display", "block");
  }
  function closeContainer() {
    i = 0;
    closePhoneCSS();
    $(".phone-container").fadeOut(850);
    $("#cursor").css("display", "none");
    

  }

  function openGoogle() {
    $(".body").fadeOut(0);
    $(".google-container").fadeIn(150);
    $(".googleHome").fadeOut(0);
    gurgling = true 
  }

  function openAssistance() {
    $(".assistance-container").fadeIn(150);
  }
  function openMessages() {
    $(".messages-container").fadeIn(150);
 
    resetScroll($(".lstMsgs"), $("#msgUp"), $("#msgDown"));
  }

  function openMessagesRead() {
    $(".message-container").fadeIn(150);
 
    resetScroll($(".lstMsgsRead"), $("#msgUp"), $("#msgDown"));
	const asd = document.getElementById('actualizamsj');
	asd.scrollTop = asd.scrollHeight;
  }

  function openNotificationsYP() {
    
    $(".assistance-container").fadeIn(150);
    $(".lstnotificationsYP").fadeIn(150);
 
    resetScroll($(".lstnotificationsYP"));
  }

  function openNotifications() {
    $(".notifications-container").fadeIn(150);
    resetScroll($(".lstnotifications"), $("#notificationsUp"), $("#notificationsDown"));
  }

  function openNewMessage() {
    $(".newMessage-container").fadeIn(150);
  }

  function openNewMessageReply(number) {
    $(".newMessage-container").fadeIn(150);
    $("#newMessage-form #number").val(number);
  }

  function openContacts() {
    $(".contacts-container").fadeIn(150);
    resetScroll($(".contacts-wrap"), $("#contactsUp"), $("#contactsDown"));
    contacting = true;
    $('#searchContacts').val("");
    $('.contactwrap').show();
  }

  function openNewContact() {
    $(".newContact-container").fadeIn(150);
  }

  function openAlerts() {
    $(".alerts-container").fadeIn(150);
    resetScroll($(".alerts-wrap"), $("#alertsUp"), $("#alertsDown"));
  }

  function openGPS() {
    $(".GPS-container").fadeIn(350);
    GPS = true
  }

  function openTwatter() {
    $(".twatter-container").fadeIn(150);
    twatting = true
  }

  function addMessageOther(item) {
    // Check if message is already added
    if (lstMsgs.some(function(e) { return e.id == item.id; })) {
      return;
    }

    lstMsgs.push(item);
    var sender =  item.name || item.sender;
    var recipient = item.recipient;
    var date = item.date;
    var d = new Date(date);
	var tiempo = time_ago(date);
    var n = d.toDateString();
    var h = d.getHours();
    var m = d.getMinutes(); 
	var msjs = renderHTML(item.message);

    if (recipient) {
      var element = $('<div id="liwrapmsg"><div class="numberAllMessages">' + sender + '</div> <div class="dateAllMessages"> ' + tiempo + '</div><div class="allmsg">' + msjs + '</div></div><hr>');  
      element.id = lstMsgs.length;  
      element.click(function(){  
        $.post('http://betrayed_phone/messageRead', JSON.stringify({id: item.id, name: sender, number: item.number, msg: item.message}));  
      });  
      $(".lstMsgs").prepend(element);
    }
  }
  function addMessage(item) {
    // Check if message is already added
    if (lstMsgs.some(function(e) { return e.id == item.id; })) {
      return;
    }
    lstMsgs.push(item);
	if (lstMsgs.some(function(e) { return e.sender == item.sender; }) && item.recipient || lstMsgs.some(function(e) { return e.receiver == item.receiver; }) && !item.recipient || lstMsgs.some(function(e) { return e.sender == item.receiver; }) && !item.recipient || lstMsgs.some(function(e) { return e.sender == item.receiver && e.sender != e.receiver; }) && item.recipient ) {
		var recipient = item.recipient;
		var date = item.date;
		var d = new Date(date);
		var n = d.toDateString();
		var tiempo = time_ago(date);
		var h = d.getHours();
		var m = d.getMinutes(); 
		var msjs = renderHTML(item.message);
		if (recipient) {
		  var sender =  item.name || item.sender;
		  var element = $('<div id="'+ item.sender +'"><div id="liwrapmsg"><div class="numberAllMessages">' + sender + '</div> <div class="dateAllMessages"> ' + tiempo + '</div><div class="allmsg">' + msjs + '</div></div><hr></div>');   
		  element.id = lstMsgs.length;  
		  element.click(function(){  
			$.post('http://betrayed_phone/messageRead', JSON.stringify({id: item.id, name: sender, number: item.sender, msg: item.message}));  
      });
		 $(".lstMsgs #"+ item.sender +"").remove()
     $(".lstMsgs").prepend(element);
		}else{
		  var sender =  item.name || item.receiver;
		  var element = $('<div id="'+ item.receiver +'"><div id="liwrapmsg"><div class="numberAllMessages">' + sender + '</div> <div class="dateAllMessages"> ' + tiempo + '</div><div class="allmsg">' + msjs + '</div></div><hr></div>');  
		  element.id = lstMsgs.length;  
		  element.click(function(){  
			$.post('http://betrayed_phone/messageRead', JSON.stringify({id: item.id, name: sender, number: item.receiver, msg: item.message}));  
		  });  
		  $(".lstMsgs #"+ item.receiver +"").remove()
		  $(".lstMsgs").prepend(element);
    }
    }else{
		var recipient = item.recipient;
		var date = item.date;
		var d = new Date(date);
		var n = d.toDateString();
		var tiempo = time_ago(date);
		var h = d.getHours();
		var m = d.getMinutes(); 
    var msjs = renderHTML(item.message);
		if (recipient) {
		  var sender =  item.name || item.sender;
		  var element = $('<div id="'+ item.sender +'"><div id="liwrapmsg"><div class="numberAllMessages">' + sender + '</div> <div class="dateAllMessages"> ' + tiempo + '</div><div class="allmsg">' + msjs + '</div></div><hr></div>');  
		  element.id = lstMsgs.length;  
		  element.click(function(){  
			$.post('http://betrayed_phone/messageRead', JSON.stringify({id: item.id, name: sender, number: item.sender, msg: item.message}));  
      });  
		  $(".lstMsgs").prepend(element);
	  }else{
		  var sender =  item.name || item.receiver;
		  var element = $('<div id="'+ item.receiver +'"><div id="liwrapmsg"><div class="numberAllMessages">' + sender + '</div> <div class="dateAllMessages"> ' + tiempo + '</div><div class="allmsg">' + msjs + '</div></div><hr></div>');  
		  element.id = lstMsgs.length;  
		  element.click(function(){  
			$.post('http://betrayed_phone/messageRead', JSON.stringify({id: item.id, name: sender, number: item.receiver, msg: item.message}));  
      });  
		  $(".lstMsgs").prepend(element);
    }
		}
  }
  
  function renderHTML(text) { 
    var rawText = strip(text)
    var urlRegex =/(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;   

    return rawText.replace(urlRegex, function(url) {   

    if ( ( url.indexOf(".jpg") > 0 ) || ( url.indexOf(".png") > 0 ) || ( url.indexOf(".gif") > 0 ) ) {
            return '<img class="imgGal" src="' + url + '">' + '<br/>'
        } else {
            return '<a >' + url + '</a>' + '<br/>'
        }
    }) 
} 
	function strip(html) 
    {  
        var tmp = document.createElement("DIV"); 
        tmp.innerHTML = html; 
        var urlRegex =/(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;   
        return tmp.innerText.replace(urlRegex, function(url) {     
        return '\n' + url 
    })
} 

  function addKey(message) {
    
    var address = escapeHtml(message.house_name)
    var house_id = message.house_id
    var house_type = message.house_model
    var owner = message.house_owner

    var amount_due = message.amount_due
    var last_payment = message.last_payment

    if ( address !== "" ) {

      if (owner === true) {
        var element = $('<div class="bubble-container2">Owner of ' + address + ' <h3><br> You owe $' + amount_due + ' <br> Last payment ' +  last_payment + ' days ago! <br> Click to Track on GPS <hr></div> ');  
      } else {
        var element = $('<div class="bubble-container2">Keyholder of ' + address + ' <h3><br> Click to Track on GPS <hr></div>');  
      }
       
      element.click(function(){  
        $.post('http://betrayed_phone/loadUserGPS', JSON.stringify({ house_id: house_id, house_type: house_type }));  
      });  

      $(element).fadeIn(100);
      $(".whitebgKeys").prepend(element);

    }

  }
  function addGPS(message) {
    
    var address = escapeHtml(message.info)
    var house_id = message.house_id
    var house_type = message.house_type

    if ( address !== "" ) {
      var element = $('<div class="bubble-container"><div class="tmsg">' + address + '</div><hr></div>');   
      element.click(function(){  
        $.post('http://betrayed_phone/loadUserGPS', JSON.stringify({ house_id: house_id, house_type: house_type }));  
      });  
      $(element).fadeIn(100);
      $(".whitebgGPS").prepend(element);
    }

  }

  function addTweet(tweets,myhandle) {
    $(".whitebg").empty();
    $(".handle").empty();
    $(".handle").prepend(myhandle);

    
    if (tweets && Object.keys(tweets).length > 0) {
      for(let message of tweets) {
        if (message && message.handle && message.message) {
          var msg = renderHTML(message.message);
          
          var tweetMSG = msg;
          if ( tweetMSG !== "" ) {
            var element = $('<div class="bubble-container"><h5>' + message.handle + '</h5><br/><div class="tmsg">' + (tweetMSG) + '</div><hr></div>');      
            element.id = message.length; 
            var img =  element.find(".imgGal");
            img.click(function(){
              $.post('http://betrayed_phone/abrirfoto', JSON.stringify({id:img.attr('src'), chat: "twitter"}));
            });
            $(".whitebg").prepend(element);
          }
        }
      }
    }
    $(".whitebg").prepend('<input id="searchTwatter" class="defaultSearch" autocomplete="off" placeholder="Search Tweet">');
  }

  function addMessageRead(item,senderN) {
    // Check if message is already added
    if (lstMsgsRead.some(function(e) { return e.id == item.id; })) {
      return;
    } 


    lstMsgsRead.push(item);
    var sender =  item.name || item.sender;

    var receiver =  item.name || item.receiver;
    var recipient = item.recipient;
    var date = item.date;
    var communicator = senderN;
    var d = new Date(date);
	  var tiempo = time_ago(date);
    var n = d.toDateString();
    var h = d.getHours();
    var m = d.getMinutes(); 
	  var msjs = renderHTML(item.message);
  


    if (recipient && communicator == item.sender) {
      
      
      if (item.gps) {
        var element = $('<div class="wrapallmsg"><div class="dateleft"> ' + tiempo + '</div><div id="liwrapmsgLeft"> <div class="msgleft"><img src="nui://betrayed_phone/html/icons/ubicacion.png"> Location</div></div></div>');  
        element.id = lstMsgsRead.length;
        element.click(function(){
          $.post('http://betrayed_phone/marcarUbicacion', JSON.stringify({coords: item.gps}));
        });
        $(".lstMsgsRead").append(element);
      } else {
        var element = $('<div class="wrapallmsg"><div class="dateleft"> ' + tiempo + '</div><div id="liwrapmsgLeft"> <div class="msgleft">' + msjs + '</div></div></div>');  
        element.id = lstMsgsRead.length;  
        element.find(".imgGal").click(function(){
          $.post('http://betrayed_phone/abrirfoto', JSON.stringify({id: element.find(".imgGal").attr('src'), chat: senderN}));
        });

        $(".lstMsgsRead").append(element);
      }
    } else {
      if (communicator == item.receiver && item.receiver != item.recipient) {
        if (item.gps) {
          var element = $('<div class="wrapallmsg"><div class="dateright"> ' + tiempo + '</div><div id="liwrapmsg"> <div class="msgright"><img src="nui://betrayed_phone/html/icons/ubicacion.png"> Location</div></div></div>');  
          element.id = lstMsgsRead.length;
          element.click(function(){
            $.post('http://betrayed_phone/marcarUbicacion', JSON.stringify({coords: item.gps}));
          });
          $(".lstMsgsRead").append(element);
        } else {
          var element = $('<div class="wrapallmsg"><div class="dateright"> ' + tiempo + '</div><div id="liwrapmsg"> <div class="msgright">' + msjs + '</div></div></div>');  
          element.id = lstMsgsRead.length;  
          element.find(".imgGal").click(function(){
            $.post('http://betrayed_phone/abrirfoto', JSON.stringify({id: element.find(".imgGal").attr('src'), chat: senderN}));
          });
  
          $(".lstMsgsRead").append(element);
        }
      }
    }

	const asd = document.getElementById('actualizamsj');
	asd.scrollTop = asd.scrollHeight;
  }

  function addYellowPages(item) {
    // Check if message is already added

    lstnotificationsYP.push(item);
    var element = $('<div id="liwrapYP"><li id="msg-' + item.id + '"><div class="msg">' + item.message + '</div> <br> <div class="number">Posted by: ' + item.name + '</div></li></div>');  
    element.id = lstnotificationsYP.length;  

    $(".lstnotificationsYP").prepend(element);
  }

  function addNotification(item) {
    // Check if message is already added

    lstnotifications.push(item);

    var element = $('<div class="message"> <div class="fromz">' + item.name + '</div><div class="subjectz">' + item.message + '</div></div><hr>');  
    element.id = lstnotifications.length;  

    $(".lstnotifications").prepend(element);
  }


  function addOutstanding(item) {
    // Check if contact is already added


    var element = $(item.textmessage + ' </div> <hr>');  

    $(".wrapoutstandingSHITLOL").append(element); 
        
  }

  function addVehicle(item) {
    // Check if contact is already added


    if ( item.canspawn == 1 ) {


      var element = $('<div class="contactwrap" id="' + item.name + '"><div class="name"> Your ' + item.name + ' (' + item.plate + ')</div><div class="number"> Located in garage ' + item.garage + ' <br> ' + item.damages + ' <br> Payments Left: ' + item.payments + ' <br> Days Since Payment ' + item.last_payment + ' <br> Amount Owing: ' + item.amount_due + '</div></div>');  
      $(".vehicles-wrap").append(element); 
      var element = $('<div class="vehtrack"> Track </div> '); 
      element.click(function(){  
        $.post('http://betrayed_phone/vehtrack', JSON.stringify({vehplate: item.plate}));  
      });  
      $(".vehicles-wrap").append(element); 

      var element = $(' <div class="vehspawn"> Spawn </div> <hr>'); 
      element.click(function(){  
        $.post('http://betrayed_phone/vehspawn', JSON.stringify({vehplate: item.plate})); 
      });  
      $(".vehicles-wrap").append(element); 

    } else {

      var element = $('<div class="contactwrap" id="' + item.name + '"><div class="name"> Your ' + item.name + ' (' + item.plate + ')</div><div class="number"> Located in garage ' + item.garage + ' <br> ' + item.damages + ' <br> Payments Left: ' + item.payments + ' <br> Days Since Payment ' + item.last_payment + ' <br> Amount Owing: ' + item.amount_due + '</div></div>');  
      $(".vehicles-wrap").append(element);

      var element = $('<div class="vehtrack"> Track </div> <hr>'); 
      element.click(function(){  
        $.post('http://betrayed_phone/vehtrack', JSON.stringify({vehplate: item.plate}));  
      });  
      $(".vehicles-wrap").append(element); 

    }
    

  }

  function addTrucker(item) {
    // Check if contact is already added


    var element = $('<div class="bubble-container22"> Delivery to ' + item.street2 + ' </div> <div class="bubble-container3"> Click to accept. </div> <hr> '); 
        
    element.click(function(){  
      $.post('http://betrayed_phone/selectedJob', JSON.stringify({jobType: item.jobType ,jobId: item.jobId}));  
    });  
    $(".trucker-wrap").append(element);

        
  }

  function addcall(item) {
    if ( item.typecall == 1 ) {

      element = $('<div class="wrapcallleft"><div class="incoming"> Incoming call </div>        <div class="taskprocess"> ' + item.contactname + '</div>  </div> <hr>');
   
    } else {

      element = $('<div class="wrapcallright"><div class="outgoing"> Outgoing call </div>        <div class="taskprocess">' + item.contactname + ' </div>    </div><hr>');
   
    }
    element.click(function(){
      $.post('http://betrayed_phone/callNumber', JSON.stringify({ callnum: item.phonenumber }));
    });
    $("#wrapcallsSHITLOL").append(element); 

  }


  function ShowGroupInfo(item) {

    element = $('<div class="wrapstock"><div class="groupbig">' + item.name + ' (' + item.cid + ') </div>        <div class="groupsmall"> Promoted By <b>' + item.giver + '</b> to Rank <b>' + item.rank + '</b>  </div>     </div>');
    $("#wrapGroupManagerSHITLOL").append(element); 

  }

  function addgroup(item) {
    element = $('<div class="wrapstock"><div class="taskname">' + item.namesent + ' </div>        <div class="taskprocess"> ' + item.ranksent + ' </div>     <div class="taskid"> Click To Manage </div>     </div>');
    element.click(function(){
      $.post('http://betrayed_phone/manageGroup', JSON.stringify({ GroupID: item.idsent }));
    });
    $("#wrapgroupSHITLOL").append(element); 
  }

  function addtask(item) {
    var element
    var classcolor
    if (item.taskstatus == "Ready For Pickup") {
      classcolor = "TaskGreen"
    } else if (item.taskstatus == "In Process") {
      classcolor = "TaskProcess2"
    } else if (item.taskstatus == "Successful") {
      classcolor = "TaskSuccess"
    } else if (item.taskstatus == "Failed") {
      classcolor = "TaskFail"
    }


    if ( item.retrace == 1 && item.taskstatus != "Successful" && item.taskstatus != "Failed" ) {
      element = $('<div class="wrapstock ' + classcolor + ' "><div class="taskname">' + item.namesent + ' </div>        <div class="taskprocess"> ' + item.taskstatus + ' </div>     <div class="taskid">Track ' + item.identifier + ' </div>     </div>');
      element.click(function(){
        $.post('http://betrayed_phone/trackTaskLocation', JSON.stringify({ TaskIdentifier: item.identifier}));
      });
      $("#wraptaskSHITLOL").append(element); 
    } else {
      element = $('<div class="wrapstock ' + classcolor + ' "><div class="taskname">' + item.namesent + ' </div>        <div class="taskprocess"> ' + item.taskstatus + ' </div>        <div class="taskid"> Id: ' + item.identifier + ' </div>      </div>');
      $("#wraptaskSHITLOL").append(element); 
    }
  }

  function addstock(item) {
    
    if (item.colorsent == 1) {
      console.log("adding stock")
      var element = $('<div class="wrapstock"><div class="stockname">' + item.namesent + ' </div>        <div class="value"> $' + item.valuesent + ' </div>        <div class="wrapprices">     <div class="share"> Shares ' + item.clientstock + '</div>            ' + item.lastchange + '               </div>        <div class="stockid"> Id: ' + item.identifier + ' </div> <div class="available"> Float: ' + item.available + ' </div>      </div>');
      $("#wrapstockSHITLOL").append(element); 

    } else {
      console.log("adding stock 2")
      var element = $('<div class="wrapstock2"><div class="stockname">' + item.namesent + ' </div>        <div class="value"> $' + item.valuesent + ' </div>                 <div class="wrapprices">                 <div class="share"> Shares ' + item.clientstock + '</div>            ' + item.lastchange + '          </div>        <div class="stockid"> Id: ' + item.identifier + ' </div> <div class="available"> Float: ' + item.available + ' </div>      </div>');
      $("#wrapstockSHITLOL").append(element); 
    }


  }

  function addContact(item) {
    // Check if contact is already added

    if (contactList.some(function(e) { return e.name == item.name && e.number == item.number; })) {
      return;
    }
    var activated
    if (item.activated == 1) {
      activated = '<span class="dotgreen"></span>'
    } else {
      activated = '<span class="dotred"></span>'
    }
    

    contactList.push(item);
    var number = item.number.toString();
    var phoneNumber = number
    var element = $('<div class="contactwrap" id="' + item.number + '"><div class="name">' + activated + ' ' + item.name + ' </div><div class="number">' + phoneNumber + '</div></div>');  

    $(".contacts-wrap").append(element); 

    var btnCall = $('<div class="contactbuttonwrap" ><a href="#" class="blacklink sans tblBtn lefttest"  data-tooltip="Call" data-position="lefttest" ><img src="nui://betrayed_phone/html/icons/call.png" "></a><hr></div>');  
    btnCall.click(function(){
      $.post('http://betrayed_phone/callContact', JSON.stringify({name: item.name, number: item.number}));
    });
    $(element).append(btnCall);




    var btnMsg = $('<div class="contactbuttonwrap" ><a href="#" class="blacklink sans tblBtn lefttest"  data-tooltip="Chat" data-position="lefttest"><img src="nui://betrayed_phone/html/icons/chathistory.png" "></a><hr></div>');  
    element.id = lstMsgs.length;  
    btnMsg.click(function(){  
      $.post('http://betrayed_phone/messageRead', JSON.stringify({number: item.number}));  
    });  
    $(element).append(btnMsg);

    var btnMsg2 = $('<div class="contactbuttonwrap" ><a href="#" class="blacklink sans tblBtn lefttest"  data-tooltip="Message" data-position="lefttest"><img src="nui://betrayed_phone/html/icons/csms.png" "></a><hr></div>');  
    btnMsg2.click(function(){
      closeAll()
      openNewMessageReply(item.number);
    });
    $(element).append(btnMsg2);


    var btnRemove = $('<div class="contactbuttonwrap" ><a href="#" class="blacklink sans tblBtn lefttest" data-tooltip="Delete" data-position="lefttest"><img src="nui://betrayed_phone/html/icons/trash.png" "></a><hr></div>');  
    btnRemove.click(function(){
      $.post('http://betrayed_phone/removeContact', JSON.stringify({name: item.name, number: item.number}));
    });
    $(element).append(btnRemove);

        
  }

  function removeContact(item) {
    $('#' + item.number).remove();
    contactList = contactList.filter(function (e) {
      return e.number != item.number;
    });
    closeAll();
    openContacts();
  }
  
   function resetgaleria() {
    $(".contacts-wrap").empty();  
	galList = [];
    resetScroll($(".contacts-wrap"), $("#cUp"), $("#galDown"));
  }
  

  function addServicio(item) {
    // Check if alert is already added
    var btnMsg = $('<a href="#" class="button sans tblBtn2">Message</a>');
    btnFinal = btnMsg
    var element = $('<div class="location"><a class="texto">' + item.nombre + ' </a>'+ btnFinal[0].outerHTML + '</div>')
    element.find(".button").click(function(){
      closeAll();
      openNewMessageReply(item.nombre);
    });
    $(".alerts-wrap").append(element);

  }
  
  function addApp(item) {
    // Check if alert is already added
    if (appList.some(function(e) { return e.id == item.id && e.location == item.location; })) {
      return;
    }

    appList.push(item); 
    
	var instalada = item.install;
	var descargando = item.descargando;
	var btnFinal = null;
	
	if (!descargando) {
		if (!instalada){
			$('.'+ item.id +'').css("display", "none");
			var $btnMsg = $('<a href="#" class="button sans tblBtn2">Install</a>');
			btnFinal = $btnMsg
		}else{
			$('.'+ item.id +'').css("display", "block");
			var btnRoute = $('<a href="#" class="button sans tblBtn2">Uninstall</a>');  
			btnFinal = btnRoute
		};
	}else{
		$('.'+ item.id +'').css("display", "none");
		btnFinal = $('<a class="button1 sans tblBtn2"><img class="imgGif" src="https://ocurus.com/images/ajax-loader.gif"></a>');
	};
	
	var element = $('<div class="location"><img class="imgIcon2" src="nui://betrayed_phone/html/icons/'+ item.id +'.png"> <a class="texto">' + item.location + ' </a>'+ btnFinal[0].outerHTML + '</div>')
	element.find(".button").click(function(){
		if (!instalada){
			$.post('http://betrayed_phone/instalarApp', JSON.stringify({id: item.id}));
		}else{
			$.post('http://betrayed_phone/desinstalarApp', JSON.stringify({id: item.id}));
		}
	});
    $(".appstore-wrap").append(element);
  }
	
  function resetAppStore() {
    $(".appstore-wrap").empty();  
	appList = [];
    resetScroll($(".appstore-wrap"), $("#AppsUp"), $("#AppsDown"));
  }

  function removeAlert(item) {
    $('#' + item.id + '-' + item.location).remove();
    alertList = alertList.filter(function (e) {
      return e.id != item.id && e.location != item.location;
    });    
    resetScroll($(".alerts-wrap"), $("#alertsUp"), $("#alertsDown"));
  }
  
  function resetgaleria() {
    $(".galeria-wrap").empty();  
	galList = [];
    resetScroll($(".galeria-wrap"), $("#galUp"), $("#galDown"));
  }
  
  function addfoto(item) {
    // Check if alert is already added
    if (galList.some(function(e) { return e.id == item.id;})) {
      return;
    }

    galList.push(item); 
    
	var element = $('<img class="imgGal" src="'+ item.id +'">')
	element.click(function(){
		$.post('http://betrayed_phone/abrirfoto', JSON.stringify({id: item.id}));
	});
    $(".galeria-wrap").prepend(element);
  }
  
  function ponerFoto(item,chat) {
	 $(".imgGrande").remove(); 
  var element = $('<img id="imageContainerId" class="imgGrande" src="'+ item +'">')
  if (chat){
    $(element).addClass("chat");
  }
    $("#fotograndeapp").before(element);
  }

  function addPackages(item) {

    var element = $('<div class="bubble-container2"> Delivery to ' + item.street2 + ' </div> <div class="bubble-container3"> Distance: '+item.distance+'. </div> <hr> '); 
    $(".packages-wrap").append(element);
  }

  // Listen for NUI Events
  window.addEventListener('message', function(event){
    var item = event.data;
    // Trigger adding a new message to the log and create its display
    if (item.newSMS === true) {
		addMessage(item.sms);
      if ($(".message-container").is(":visible")) {
        var message = item.sms
        if (escapeHtml($(".numberReading").text()) == message.receiver || escapeHtml($(".numberReading").text()) == message.sender) {
          var sendero = escapeHtml($(".numberReading").text());
         addMessageRead(message,sendero);
        }
      }
    }
    if(item.newContact === true) {
      addContact(item.contact);
    }
    if (item.emptyContacts === true) {
      contactList = [];
      $(".contacts-wrap").empty();
    }




    if (item.openSection == "timeheader") {    
      $(".timeheader").empty();
      $(".timeheader").html(item.timestamp);
    }

    if (item.openSection == "enableoutstanding") {
      closeAll();
      $(".realestateOutstanding-container").fadeIn(100);     
      $(".wrapoutstandingSHITLOL").empty();
    }

    if (item.openSection == "callStatus") {
      if (item.status == 0) {
        $(".btnAnswer").fadeOut(0);
        $(".btnHangup").fadeOut(0);
      }
      if (item.status == 1) {
        $(".btnAnswer").fadeOut(0);
        $(".btnHangup").fadeIn(0);
      }
      if (item.status == 2) {
        $(".btnAnswer").fadeIn(0);
        $(".btnHangup").fadeIn(0);
      }  
      if (item.status == 3) {
        $(".btnAnswer").fadeOut(0);
        $(".btnHangup").fadeIn(0);
      }          
    }
    

    if(item.openSection == "inputoutstanding") {
      addOutstanding(item);
    }

    if(item.openSection == "carpaymentsowed") {
      $(".btnOutstanding").fadeIn(100);      
    }
	
	if(item.openSection == "fotogrande") {
      closeAll();
      $(".fotogrande-container").fadeIn(100);
      if (item.chat) {
        ponerFoto(item.foto,true);
        $(".btnVGaleria").fadeOut(1);
        $(".btnVChat").fadeIn(1); 
      }else{
        ponerFoto(item.foto,false);
        $(".btnVGaleria").fadeIn(1); 
        $(".btnVChat").fadeOut(1);
      };
      if (item.guardada) {
        $(".btnGuardarFoto").fadeOut(1);
        $(".btnBorrarFoto").fadeIn(1); 
      }else{
        $(".btnGuardarFoto").fadeIn(1); 
        $(".btnBorrarFoto").fadeOut(1);
      };
    }

    if(item.openSection == "closeQuick") {
      closeAll();
    }

    if(item.openSection == "addcar") {
      addVehicle(item);
    }

    if(item.openSection == "addtrucker") {
      addTrucker(item);
    }

    if(item.openSection == "addPackages") {
      addPackages(item);
    }

    if(item.openSection == "calls") {
      closeAll();
      $(".calls-container").fadeIn(100);
    }

    if(item.openSection == "RealEstate") {
      closeAll();
      $(".realestate-container").fadeIn(100);
    }




    if(item.openSection == "error") {
      closeAll();
      $(".noperm").empty();
      $(".noperm").html(item.textmessage);
      $(".error-container").fadeIn(100);
    }

    if(item.removeContact === true) {
      removeContact(item.contact);
    }
    if(item.nuevoServicio === true) {
      addServicio(item.servicio);      
    }
	
	if(item.newFoto === true) {
      addfoto(item.foto);      
    }
	
	if(item.newApp === true) {
      addApp(item.app);      
    }
	
	if(item.resetappstore === true) {
      resetAppStore()    
    }	
	
	if(item.descargando === true) {
      $('.descargando').css("display", "block");     
    }
	
	if(item.descargando === false) {
       $('.descargando').css("display", "none");       
    }
	
    if(item.removeAlert === true) {
      removeAlert(item.alert);
    }
	

    // Open & Close main phone window
    if(item.openPhone === true) {
      disableEmails();
      disableDecrypt();
      disableDecrypt2();
      disableTrucker();
	  fondopantalla = item.fondo;
	  $("#minumero").html(item.numero);
      openContainer();
      openMain();
    }
	
    if(item.hasDevice === true) {
      enableEmails();
    }
    if(item.hasDecrypt === true) {
      enableDecrypt();
    }
    if(item.hasDecrypt2 === true) {
      enableDecrypt2();
    }

    if(item.hasTrucker === true) {
      enableTrucker();
    }     

    if(item.openSection == "garages") {
      $(".vehicles-container").fadeIn(100);
      $(".vehicles-wrap").empty();
    }

    if(item.openSection == "trucker") {
      $(".trucker-wrap").empty();
      $(".trucker-container").fadeIn(100);
    }

    if(item.openSection == "packages") {
      $(".packages-wrap").empty();
      $(".packages-container").fadeIn(100);
      $(".btnRequest").fadeOut(0);
    }

    if(item.openSection == "packagesWith") {
      $(".packages-wrap").empty();
      $(".packages-container").fadeIn(100);
      $(".btnRequest").fadeIn(0);
    }

    if(item.openSection == "addstock") {
      addstock(item)
    }


    if(item.openSection == "newsms") {
      $(".phonealerts-container").fadeIn(50);
      $(".newsms").fadeIn(100);
    }

    if(item.openSection == "newemail") {
      $(".phonealerts-container").fadeIn(50);
      $(".newemail").fadeIn(100);
    }

    if(item.openSection == "newtweet") {
      $(".phonealerts-container").fadeIn(50);
      $(".newtweet").fadeIn(100);
    }

    if(item.openSection == "addtask") {
      addtask(item)
    }


    if(item.openSection == "addcall") {
      addcall(item)
    }

    if(item.openSection == "addgroup") {
      addgroup(item)
    }
    if(item.openSection == "GroupManager") {

      closeAll();
      $("#wrapGroupManagerSHITLOL").empty();
      $(".bank").empty();
      $(".bank").html(item.sentbank);
      $("#payCash-form #gangidpay").val(item.sentgroupid);
      $("#newRank-form #gangidrank").val(item.sentgroupid);
      $("#addBank-form #gangidbank").val(item.sentgroupid);

      $(".GroupManager-container").fadeIn(50);
      
    }

    if(item.openSection == "GroupManagerUpdate") {
      ShowGroupInfo(item.info);
    }

    if(item.openSection == "updateMessages") {
      if ( item.lstMsgs === undefined ) {
      } else {
        lstMsgs = item.lstMsgs
      }
    }

    if(item.openSection == "account") {
      closeAll();
    
      $(".account-container").fadeIn(100);
      $("#footer-information").html(item.InfoString);
    }

    if(item.openSection == "twatter") {
      closeAll();
      openTwatter();
      curtwats = item.twats
      addTweet(curtwats,item.myhandle);
    }


    if(item.openSection == "notify") {
      closeAll();
      $(".twatter-container2").fadeIn(1000);
      $(".whitebg2").empty();
      var element = $('<div class="bubble-container"><h5>' + item.handle + '</h5><br/><div class="tmsg2">' + item.message + '</div><hr></div>');      
      element.id = item.message.length;  
      $(".whitebg2").prepend(element);
      $(".twatter-container2").fadeOut(10000);
    }









    if(item.openSection == "GPS") {
      closeAll();
      openGPS();
      

    }

    if(item.openSection == "AddGPSLocation") {
      addGPS(item);
    }
    if(item.openPhone === false) {
      closeAll();
      closeContainer();
      closeMain();
    }

    if(item.openSection == "keys") {

      $(".keys-container").fadeIn(150); 

      document.getElementById("whitebgKeys").innerHTML = "";
    }

    if(item.openSection == "keysend") {
      $("#whitebgKeys").prepend("<h2>Your Keycards</h2>"); 

    }

    if(item.openSection == "key") {
      addKey(item);
    }

    if (item.toggleAlerts === true) {
      canShowAlerts = item.status;
      $(".btnAlerts").fadeIn(150); 
    }    

    if (item.type == "click") {
      //triggerClick(cursorX - 1, cursorY - 1);
    }
    // Open sub-windows / partials



    if(item.openSection == "assistance") {
      closeAll();
      openAssistance();
    }

    if(item.openSection == "google") {
      closeAll();
      openGoogle();
      searchGoogleUpdate()
    }

    if(item.openSection == "websiteAdd") {

      var webTitle = escapeHtml(item.webTitle)
      var webKeywords = escapeHtml(item.webKeywords)
      var webDescription = escapeHtml(item.webDescription)
      $("#nukeDiv").append("<div class='googleResult'><div id='keywords' style='display:none;'>" + webKeywords + "</div><a href='#' class='googleLink btnGoogleCar'>" + webTitle + "</a><div class='description'>" + webDescription + "</div></div>")
    }



    if(item.openSection == "messageRead") {
      lstMsgsRead.length = 0;
      $(".lstMsgsRead").empty();
      $(".numberReading").empty();
      $(".numberReading").append(item.senderN);
      var btnRemove = $('<div class="contactbuttonwrap2" ><a href="#" class="blacklink sans tblBtn bottom" data-tooltip="Delete" data-position="bottom"><img src="nui://betrayed_phone/html/icons/trash.png"></a></div>');
      var btnGPS = $('<div class="contactbuttonwrap1" ><a href="#" class="blacklink sans tblBtn bottom" data-tooltip="Location" data-position="bottom"><img src="nui://betrayed_phone/html/icons/ubicacion.png"></a></div>'); 
      if (!item.agendado) {
        var btnAgendar = $('<div class="contactbuttonwrap1" ><a href="#" class="blacklink sans tblBtn bottom" data-tooltip="Add" data-position="bottom"><img src="nui://betrayed_phone/html/icons/agregar.png"></a></div>'); 
        $(".numberReading").prepend(btnAgendar);
        btnAgendar.click(function(){
          closeAll();
          openNewContact();
          $("#newContact-form #number").val(item.senderN);
        });
        
      }
       btnRemove.click(function(){
         $(".popup-container").fadeIn(150); 
         $(".popuptext").empty();
         $(".popuptext").text("You want to delete the entire chat?");
         $(".two-button").empty();
         var aceptarPopup = $('<a href="#" class="button-pop popAceptar">Accept</a>');
         var cacelarPopup = $('<a href="#" class="button-pop popCancelar">Cancel</a>'); 
         $(".two-button").prepend(cacelarPopup);
         $(".two-button").prepend(aceptarPopup);
         aceptarPopup.click(function(){
          $(".popup-container").fadeOut(50);
          closeAll();
          $.post('http://betrayed_phone/borrarChat', JSON.stringify({
              number: item.senderN,
            }));
         });
         cacelarPopup.click(function(){
          $(".popup-container").fadeOut(50);
         });
       });
       btnGPS.click(function(){
          $(".popup-container").fadeIn(150); 
          $(".popuptext").empty();
          $(".popuptext").text("Do you want to send your location?");
          $(".two-button").empty();
          var aceptarPopup = $('<a href="#" class="button-pop popAceptar">Accept</a>');
          var cacelarPopup = $('<a href="#" class="button-pop popCancelar">Cancel</a>'); 
          $(".two-button").prepend(cacelarPopup);
          $(".two-button").prepend(aceptarPopup);
          aceptarPopup.click(function(){
           $(".popup-container").fadeOut(50)
           $.post('http://betrayed_phone/newMessageSubmit', JSON.stringify({
              number: item.senderN,
              message: "Location",
              gps: true
            }));
          });
          cacelarPopup.click(function(){
            $(".popup-container").fadeOut(50);
           });
        });
    $(".numberReading").prepend(btnGPS);
    $(".numberReading").prepend(btnRemove);
      if (item.list && Object.keys(item.list).length > 0) {
        for(let message of item.list) {
          if (message && message.receiver && message.message) {
            addMessageRead(message,item.senderN);
          }
        }
      }
      closeAll();
      openMessagesRead();
    }


    if(item.openSection == "messagesOther") {
      lstMsgs.length = 0;
      $(".lstMsgs").empty();
      if (item.list && Object.keys(item.list).length > 0) {
        for(let message of item.list) {
          if (message && message.receiver && message.message) {
            addMessageOther(message);
          }
        }
      }
      closeAll();
      openMessages();
    }

    if(item.openSection == "messages") {
      lstMsgs.length = 0;
      $(".lstMsgs").empty();
      if (item.list && Object.keys(item.list).length > 0) {
        for(let message of item.list) {
          if (message && message.receiver && message.message) {
            addMessage(message);
          }
        }
      }
      closeAll();
      openMessages();
    }

    if(item.openSection == "messagesAct") {
      lstMsgs.length = 0;
      $(".lstMsgs").empty();
      if (item.list && Object.keys(item.list).length > 0) {
        for(let message of item.list) {
          if (message && message.receiver && message.message) {
            addMessage(message);
          }
        }
      }
    }

    if(item.openSection == "notificationsYP") {
      lstMsgs.length = 0;
      $(".lstnotificationsYP").empty();
      if (item.list && Object.keys(item.list).length > 0) {
        for(let message of item.list) {
          if (message) {
            addYellowPages(message);
          }
        }
      }

      openNotificationsYP();
    }  







    if(item.openSection == "notifications") {
      lstMsgs.length = 0;
      $(".lstnotifications").empty();
      if (item.list && Object.keys(item.list).length > 0) {
        for(let message of item.list) {
          if (message) {
            addNotification(message);
          }
        }
      }
      closeAll();
      openNotifications();
    }  






    if(item.openSection == "deepweb") {
      closeAll();
      openBrowser3();
    }




    if(item.openSection == "taskUpdated") {
      closeAll();
      $(".gangtask-container").fadeIn(100);
      $("#wraptaskSHITLOL").empty();
    }



    if(item.openSection == "newMessage") {
      closeAll();
      openNewMessage();
    }
    if(item.openSection == "newMessageReply") {
      closeAll();
      openNewMessageReply(item.number);
    }
    if(item.openSection == "contacts") {
      closeAll();
      openContacts();
    }
    if (item.openSection == "newContact") {
      closeAll();
      openNewContact();      
    }
    if(item.openSection == "alerts") {
      closeAll();
      openAlerts();
    }
  });
  $(document).mousemove(function(event) {
    cursorX = event.pageX;
    cursorY = event.pageY;
    UpdateCursorPos();
  });
	
  // Handle Button Presses
  $(".btnHome").click(function(){
      closeAll();
      openHome();
      $.post('http://betrayed_phone/resetPackages', JSON.stringify({}));
  });

  $(".btnBox1").click(function(){

      $.post('http://betrayed_phone/btnBox1', JSON.stringify({}));
  });

  $(".btnBox2").click(function(){

      $.post('http://betrayed_phone/btnBox2', JSON.stringify({}));
  });

  $(".btnBox3").click(function(){

      $.post('http://betrayed_phone/btnBox3', JSON.stringify({}));
  });

  $(".btnNotifyToggle").click(function(){
      $.post('http://betrayed_phone/btnNotifyToggle', JSON.stringify({}));
  });  

  $(".btnDelivery").click(function(){
      $.post('http://betrayed_phone/btnDelivery', JSON.stringify({}));
  });

  $(".btnPackages").click(function(){
      $.post('http://betrayed_phone/btnPackages', JSON.stringify({}));
      closeAll();
  });

  $(".btnStocks").click(function(){
      closeAll();
      $(".stock-container").fadeIn(100);
      $("#wrapstockSHITLOL").empty();
      $.post('http://betrayed_phone/btnStocks', JSON.stringify({}));
  });

  $(".btnTaskGang").click(function(){
      closeAll();
      $(".gangtask-container").fadeIn(100);
       $("#wraptaskSHITLOL").empty();
      $.post('http://betrayed_phone/btnTaskGang', JSON.stringify({}));
  });

  $(".btnTaskGroups").click(function(){
      closeAll();
      $(".group-container").fadeIn(100);
      $("#wrapgroupSHITLOL").empty();
      $.post('http://betrayed_phone/btnTaskGroups', JSON.stringify({}));
  });
  $(".btnConfig").click(function(){
      closeAll();
      $(".config-container").fadeIn(100);
  });
  
   $(".btnGaleria").click(function(){
      closeAll();
	  resetgaleria();
	  $.post('http://betrayed_phone/btnGaleria', JSON.stringify({}));
      $(".galeria-container").fadeIn(100);
	  resetScroll($(".galeria-wrap"), $("#galUp"), $("#galDown"));
  });

  $(".btnVGaleria").click(function(){
      closeAll();
    resetgaleria();
    $.post('http://betrayed_phone/btnGaleria', JSON.stringify({}));
      $(".galeria-container").fadeIn(100);
    resetScroll($(".galeria-wrap"), $("#galUp"), $("#galDown"));
  });

  $(".btnVChat").click(function(){
    closeAll();
    $.post('http://betrayed_phone/btnVChat', JSON.stringify({}));  
  });
  
  $(".btnAppStore").click(function(){
      closeAll();
	  $.post('http://betrayed_phone/btnAppStore', JSON.stringify({}));
      $(".appstore-container").fadeIn(100);
	  resetScroll($(".appstore-wrap"), $("#AppsUp"), $("#AppsDown"));
  });

  $(".btnTwatter").click(function(){
      $.post('http://betrayed_phone/btnTwatter', JSON.stringify({}));
  });

  $(".btnGarage").click(function(){
      $.post('http://betrayed_phone/btnGarage', JSON.stringify({}));
      closeAll();
  });

  $(".btnAnswer").click(function(){
      $.post('http://betrayed_phone/btnAnswer', JSON.stringify({}));
  });

  $(".btnHangup").click(function(){
      $.post('http://betrayed_phone/btnHangup', JSON.stringify({}));
  });

  $(".btnRequest").click(function(){
    $(".btnRequest").fadeOut(0);
      $.post('http://betrayed_phone/btnRequest', JSON.stringify({}));
  });

  $(".btnPropertyClothing").click(function(){
      $.post('http://betrayed_phone/btnPropertyClothing', JSON.stringify({}));
  });

  $(".btnPropertyStorage").click(function(){
      $.post('http://betrayed_phone/btnPropertyStorage', JSON.stringify({}));
  });




  $(".btnPropertyStopHouse").click(function(){
      $.post('http://betrayed_phone/btnPropertyStopHouse', JSON.stringify({}));
  });

  $(".btnPropertyHouseCreationPoint").click(function(){
      $.post('http://betrayed_phone/btnPropertyHouseCreationPoint', JSON.stringify({}));
  });


  $(".btnPropertyModify").click(function(){
      $.post('http://betrayed_phone/btnPropertyModify', JSON.stringify({}));
  });


  $(".btnPropertyReset").click(function(){
      $.post('http://betrayed_phone/btnPropertyReset', JSON.stringify({}));
  });


  $(".btnPropertySetGarage").click(function(){
      $.post('http://betrayed_phone/btnPropertySetGarage', JSON.stringify({}));
  });


  $(".btnPropertyWipeGarages").click(function(){
      $.post('http://betrayed_phone/btnPropertyWipeGarages', JSON.stringify({}));
  });


  $(".btnPropertySetBackdoorInside").click(function(){
      $.post('http://betrayed_phone/btnPropertySetBackdoorInside', JSON.stringify({}));
  });


  $(".btnPropertySetBackdoorOutside").click(function(){
      $.post('http://betrayed_phone/btnPropertySetBackdoorOutside', JSON.stringify({}));
  });

  $(".btnPropertyUpdateHouse").click(function(){
      $.post('http://betrayed_phone/btnPropertyUpdateHouse', JSON.stringify({}));
  });

  $(".btnPropertyUnlock").click(function(){
      $.post('http://betrayed_phone/btnPropertyUnlock', JSON.stringify({}));
  });

  $(".btnHelp").click(function(){
      closeAll()
      $(".home").fadeOut(150);
      $.post('http://betrayed_phone/btnHelp', JSON.stringify({}));
  });

  $(".btnMute").click(function(){
      $.post('http://betrayed_phone/btnMute', JSON.stringify({}));
  });
  
  $(".btnOculto").click(function(){
      $.post('http://betrayed_phone/btnOculto', JSON.stringify({}));
  });

  $(".btnGiveTask").click(function(){
      closeAll();
      $.post('http://betrayed_phone/btnGiveTaskToPlayer', JSON.stringify({
          taskid: escapeHtml($("#newTask-form #taskid").val()),
          targetid: escapeHtml($("#newTask-form #targetid").val()),
      }));
  });
  
  $(".btnCamara").click(function(){
      closeAll();
	  $.post('http://betrayed_phone/close', JSON.stringify({}));
      $.post('http://betrayed_phone/btnCamara', JSON.stringify({
      }));
  });

  $(".btnPropertySell").click(function(){
     
      $.post('http://betrayed_phone/btnAttemptHouseSale', JSON.stringify({
          cid: escapeHtml($("#buyProperty-form #cid").val()),
          price: escapeHtml($("#buyProperty-form #PropertyPrice").val()),
      }));
      $.post('http://betrayed_phone/close', JSON.stringify({}));
  });
  
  $(".btnAplicarFondo").click(function(){
    var url = $("#aplicarfondo #urlfondo").val();
    $("#aplicarfondo").trigger("reset");
	  var esimg = checkURL(url);
	  if (esimg) {
		  testImage(url, function(returnValue) {
			  if (returnValue) {
				  fondopantalla = url
				  $.post('http://betrayed_phone/actualizarURLFondo', JSON.stringify({
					  fondo: url,
				  }));
			  }else{
				$.post('http://betrayed_phone/errorimg', JSON.stringify({}));
        fondopantalla = 'nui://betrayed_phone/html/fondo.jpg';
        $.post('http://betrayed_phone/BaseURLFondo', JSON.stringify({
					  fondo: fondopantalla,
				  }));
			  };
		  });
	  }else{
		 $.post('http://betrayed_phone/errorimg', JSON.stringify({}));
     fondopantalla = 'nui://betrayed_phone/html/fondo.jpg';
     $.post('http://betrayed_phone/BaseURLFondo', JSON.stringify({
					  fondo: fondopantalla,
				  }));
    };
   
  });
  
  $(".btnVerEnorme").click(function(){
	
    var url = $('#imageContainerId').prop('src')
    var hasClass = $('#imageContainerId').hasClass("chat");
	  var esimg = checkURL(url);
	  if (esimg) {
		  testImage(url, function(returnValue) {
		  if (returnValue) {
			  openFotoEnorme(url,hasClass)
		  }else{
			  console.log("Error al cargar la imagen")
		  };
		  });
	  }else{
      console.log("Error al cargar la imagen")
	  };
  });
  
  function isEmpty(str) {
    return !str.trim().length;
	}

  $( "#contestar" ).submit(function( event ) {
	event.preventDefault();
	if (!isEmpty(escapeHtml($("#contestar #respuesta").val())) || (escapeHtml($("#contestar #respuesta").val()) != "")) {
		$.post('http://betrayed_phone/newMessageSubmit', JSON.stringify({
			  number: escapeHtml($(".numberReading").text()),
			  message: escapeHtml($("#contestar #respuesta").val())
		  }));
		document.getElementById("contestar").reset();
	};
});

  $(".promoteGroup").click(function(){
      closeAll();
      $.post('http://betrayed_phone/promoteGroup', JSON.stringify({
          gangid: escapeHtml($("#newRank-form #gangidrank").val()),
          cid: escapeHtml($("#newRank-form #cid").val()),
          newrank: escapeHtml($("#newRank-form #newrank").val()),
      }));
  });
  $(".bankGroup").click(function(){
      closeAll();
      $.post('http://betrayed_phone/bankGroup', JSON.stringify({
          gangid: escapeHtml($("#addBank-form #gangidbank").val()),
          cashamount: escapeHtml($("#addBank-form #cashamount").val()),
      }));
  });

  $(".payGroup").click(function(){
      closeAll();
      $.post('http://betrayed_phone/payGroup', JSON.stringify({
          gangid: escapeHtml($("#payCash-form #gangidpay").val()),
          cid: escapeHtml($("#payCash-form #cid").val()),
          cashamount: escapeHtml($("#payCash-form #cashamount").val()),
      }));
  });

  $(".btnKey").click(function(){
      $.post('http://betrayed_phone/btnGiveKey', JSON.stringify({}));
  });


  $(".btnFurniture").click(function(){
      $.post('http://betrayed_phone/btnFurniture', JSON.stringify({}));
  });

  $(".btnPropertyOutstanding").click(function(){
      $.post('http://betrayed_phone/btnPropertyOutstanding', JSON.stringify({}));
  });

  $(".btnMortgage").click(function(){
      $.post('http://betrayed_phone/btnMortgage', JSON.stringify({}));
  });

  $(".btnWipeKeys").click(function(){
      $.post('http://betrayed_phone/btnWipeKeys', JSON.stringify({}));
  });

  $(".btnSendStock").click(function(){
      $.post('http://betrayed_phone/stocksTradeToPlayer', JSON.stringify({
          identifier: escapeHtml($("#newStock-form #stockid").val()),
          playerid: escapeHtml($("#newStock-form #targetid").val()),
          amount: escapeHtml($("#newStock-form #amount").val()),
      }));
      $("#wrapstockSHITLOL").empty();
  });

  $(".btnStances").click(function(){
      $.post('http://betrayed_phone/btnStances', JSON.stringify({}));
  });
  $(".btnMarkers").click(function(){
      $.post('http://betrayed_phone/btnMarkers', JSON.stringify({}));
  });


  $(".btnProperty2").click(function(){
      $.post('http://betrayed_phone/btnProperty2', JSON.stringify({}));
  });
  $(".btnProperty").click(function(){
      $.post('http://betrayed_phone/btnProperty', JSON.stringify({}));
  });
  $(".btnProps").click(function(){
      $.post('http://betrayed_phone/btnProps', JSON.stringify({}));
  });
  $(".btnPhoneNumber").click(function(){
      $.post('http://betrayed_phone/btnPhoneNumber', JSON.stringify({}));
  });
  $(".btnShowId").click(function(){
      $.post('http://betrayed_phone/btnShowId', JSON.stringify({}));
  });

  $(".btnEmotes").click(function(){
      $.post('http://betrayed_phone/btnEmotes', JSON.stringify({}));
  });
  $(".btnPagerType").click(function(){
      closeAll();
      $.post('http://betrayed_phone/btnPagerType', JSON.stringify({}));
      $(".secondary-container").fadeIn(300);
  });

  $(".2ndRemove").click(function(){
      $.post('http://betrayed_phone/2ndRemove', JSON.stringify({}));
  });

  $(".2ndWeedSt").click(function(){
      $.post('http://betrayed_phone/2ndWeedSt', JSON.stringify({}));
  });

  $(".2ndWeedHigh").click(function(){
      $.post('http://betrayed_phone/2ndWeedHigh', JSON.stringify({}));
  });

  $(".2ndMethSt").click(function(){
      $.post('http://betrayed_phone/2ndMethSt', JSON.stringify({}));
  });

  $(".2ndMethHigh").click(function(){
      $.post('http://betrayed_phone/2ndMethHigh', JSON.stringify({}));
  });

  $(".2ndGunSt").click(function(){
      $.post('http://betrayed_phone/2ndGunSt', JSON.stringify({}));
  });

  $(".2ndGunHigh").click(function(){
      $.post('http://betrayed_phone/2ndGunHigh', JSON.stringify({}));
  });

  $(".2ndGunSmith").click(function(){
      $.post('http://betrayed_phone/2ndGunSmith', JSON.stringify({}));
  });

  $(".2ndMoneyCleaner").click(function(){
      $.post('http://betrayed_phone/2ndMoneyCleaner', JSON.stringify({}));
  });

  $(".2ndMoneySt").click(function(){
      $.post('http://betrayed_phone/2ndMoneySt', JSON.stringify({}));
  });

  $(".2ndMoneyHigh").click(function(){
      $.post('http://betrayed_phone/2ndMoneyHigh', JSON.stringify({}));
  });


  $(".btnTrucker").click(function(){
    $.post('http://betrayed_phone/btnTrucker', JSON.stringify({}));
    closeAll();
  });

  $(".btnDecrypt2").click(function(){

      $.post('http://betrayed_phone/btnCamera', JSON.stringify({}));
      openBrowser2();


  });

  $(".btnOutstanding").click(function(){

      $.post('http://betrayed_phone/carpaymentsowed', JSON.stringify({}));

  });


  $(".btnDecrypt").click(function(){

      $.post('http://betrayed_phone/btnDecrypt', JSON.stringify({}));
  });

  $(".btnPagerToggle").click(function(){

      $.post('http://betrayed_phone/btnPagerToggle', JSON.stringify({}));
  });
  $(".btnCarKey").click(function(){
      $.post('http://betrayed_phone/btnCarKey', JSON.stringify({}));
  });
  $(".btnHouseKey").click(function(){
      $.post('http://betrayed_phone/btnHouseKey', JSON.stringify({}));
  });


  $(".btnAccount").click(function(){
      $.post('http://betrayed_phone/btnAccount', JSON.stringify({}));
  });

  $(".btnCamera").click(function(){
      $.post('http://betrayed_phone/btnCamera', JSON.stringify({}));
      openBrowser();


  });

  $(".btnClose").click(function(){
      $.post('http://betrayed_phone/close', JSON.stringify({}));
  });
  $(".btnAssistance").click(function(){
      $.post('http://betrayed_phone/assistance', JSON.stringify({}));
      $.post('http://betrayed_phone/notificationsYP', JSON.stringify({}));
  });
  $(".btnEMS").click(function(){
      $.post('http://betrayed_phone/assistEMS', JSON.stringify({message: 'Requesting medical assistance'}));
  });
  $(".btnTaxi").click(function(){
      $.post('http://betrayed_phone/assistTaxi', JSON.stringify({message: 'Requesting a taxi'}));
  });
  $(".btnTow").click(function(){
      $.post('http://betrayed_phone/assistTow', JSON.stringify({message: 'Requesting a tow'}));
  });

  $(".btnMessages").click(function(){
      $.post('http://betrayed_phone/messages', JSON.stringify({}));
  });

  $(".btnGoogle").click(function(){
      $.post('http://betrayed_phone/google', JSON.stringify({}));
  });

  $(".btnNotifications").click(function(){
      $.post('http://betrayed_phone/notifications', JSON.stringify({}));
  });

  $(".btnReply").click(function(){
      $.post('http://betrayed_phone/messageReply', JSON.stringify({
          number: escapeHtml($("#message-num").val())
      }));
  });
  $(".btnDeleteSMS").click(function(e){
      e.preventDefault();
      $(".btnDeleteSMS").prop('disabled', true);
      $.post('http://betrayed_phone/messageDelete', JSON.stringify({
          id: escapeHtml($("#message-id").val()),
          number: escapeHtml($("#message-num").val())
      }));
      closeAll();
      openMain();
      $(".btnDeleteSMS").prop('disabled', false);
  });
  $(".btnNewMessage").click(function(e){
      e.preventDefault();
      $.post('http://betrayed_phone/newMessage', JSON.stringify({}));
  });
  $(".btnContacts").click(function(e){
      e.preventDefault();
      $.post('http://betrayed_phone/contacts', JSON.stringify({}));
  });
  $(".btnNewContact").click(function(e){
      e.preventDefault();
      $.post('http://betrayed_phone/newContact', JSON.stringify({}));
  });
  $(".btnAlerts").click(function(e){
      e.preventDefault();
      $.post('http://betrayed_phone/assistAlerts', JSON.stringify({}));
  });

  $("#notificationsUp").click(function(e){
      e.preventDefault();
      scroll(0, $(".lstnotifications"), $("#notificationsUp"), $("#notificationsDown"));
  });
  $("#notificationsDown").click(function(e){
      e.preventDefault();
      scroll(1, $(".lstnotifications"), $("#notificationsUp"), $("#notificationsDown"));
  });

  $("#msgUp").click(function(e){
      e.preventDefault();
      scroll(0, $(".lstMsgs"), $("#msgUp"), $("#msgDown"));
  });
  $("#msgDown").click(function(e){
      e.preventDefault();
      scroll(1, $(".lstMsgs"), $("#msgUp"), $("#msgDown"));
  });

  $("#contactsUp").click(function(e){
      e.preventDefault();
      scroll(0, $(".contacts-wrap"), $("#contactsUp"), $("#contactsDown"));
  });
  $("#contactsDown").click(function(e){
      e.preventDefault();
      scroll(1, $(".contacts-wrap"), $("#contactsUp"), $("#contactsDown"));
  });

  $("#alertsUp").click(function(e){
      e.preventDefault();
      scroll(0, $(".alerts-wrap"), $("#alertsUp"), $("#alertsDown"));
  });
  $("#alertsDown").click(function(e){
      e.preventDefault();
      scroll(1, $(".alerts-wrap"), $("#alertsUp"), $("#alertsDown"));
  });
  
  $("#AppsUp").click(function(e){
      e.preventDefault();
      scroll(0, $(".appstore-wrap"), $("#AppsUp"), $("#AppsDown"));
  });
  $("#AppsDown").click(function(e){
      e.preventDefault();
      scroll(1, $(".appstore-wrap"), $("#AppsUp"), $("#AppsDown"));
  });
  
  $("#galUp").click(function(e){
      e.preventDefault();
      scroll(0, $(".galeria-wrap"), $("#galUp"), $("#galDown"));
  });
  $("#galDown").click(function(e){
      e.preventDefault();
      scroll(1, $(".galeria-wrap"), $("#galUp"), $("#galDown"));
  });
	
  $(".btnCopiarLink").click(function(e){
      e.preventDefault();
      var url = $('#imageContainerId').prop('src');
		copyToClipboard(url);
	  $.post('http://betrayed_phone/copiarURL', JSON.stringify({
      }));
  });
  
  $(".btnGuardarFoto").click(function(e){
      e.preventDefault();
      var url = $('#imageContainerId').prop('src');
      var hasClass = $('#imageContainerId').hasClass("chat");
	  $.post('http://betrayed_phone/guardarfoto', JSON.stringify({
          url: url,
          chat: hasClass,
      }));
  });
  
  $(".btnBorrarFoto").click(function(e){
      e.preventDefault();
      var url = $('#imageContainerId').prop('src');
      var hasClass = $('#imageContainerId').hasClass("chat");
	  $.post('http://betrayed_phone/borrarfoto', JSON.stringify({
          url: url,
          chat: hasClass,
      }));
  });

	
	function copyToClipboard(id) {
	  var text = id
		var elem = document.createElement("textarea");
		document.body.appendChild(elem);
		elem.value = text;
		elem.select();
		document.execCommand("copy");
		document.body.removeChild(elem);
	}
	
	function checkURL(url) {
		return(url.match(/\.(jpeg|jpg|gif|png)$/) != null);
	}
	
   function testImage(url, callback,timeout) {
    timeout = timeout || 5000;
    var timedOut = false, timer;
    var img = new Image();
    img.onerror = img.onabort = function() {
        if (!timedOut) {
            clearTimeout(timer);
            callback(false);
        }
    };
    img.onload = function() {
        if (!timedOut) {
            clearTimeout(timer);
			callback(true);
        }
    };
    img.src = url;
    timer = setTimeout(function() {
        timedOut = true;
		callback(false);
    }, timeout); 
	}


  function scroll(dir, elem, btnUp, btnDown) {
    if (dir === 0) {      
      btnDown.prop("disabled", false);
      elem.scrollTop(elem.scrollTop()  - 50);

      if (elem.scrollTop() < 50) {
        btnUp.prop("disabled", true);
      }
    } else {
      btnUp.prop("disabled", false);
      elem.scrollTop(elem.scrollTop() + 50);

      if ((elem.scrollTop() + elem.height() + 50) >= elem.prop("scrollHeight")) {
        btnDown.prop("disabled", true);
      }
    }
  }

  function resetScroll(elem, btnUp, btnDown) {
    if (elem.prop('scrollHeight') > elem.prop('clientHeight')) {
      btnUp.css("display", 'block');
      btnDown.css("display", 'block');
    }
    elem.scrollTop(0);
  }

  
  
  
  // Handle Form Submits

  $(".btnSubmitYP").click(function(e){
      e.preventDefault();
      $.post('http://betrayed_phone/newPostSubmit', JSON.stringify({
          advert: escapeHtml($("#newAdvert-form #postAdvert").val())
      }));
      $("#newAdvert-form #postAdvert").val('')
      closeAll()
  });

  $(".btnDeleteAdvert").click(function(e){
      $.post('http://betrayed_phone/deleteYP', JSON.stringify({}));
      closeAll()
  });



  $("#newTweet-form").submit(function(e) {
      e.preventDefault();
      $.post('http://betrayed_phone/newTwatSubmit', JSON.stringify({
          twat: escapeHtml($("#newTweet-form #postTwatter").val())
      }));
      $("#newTweet-form #postTwatter").val('')
      closeAll()
  });

  $(".btnSendSMS").click(function(e){
      e.preventDefault();
      $.post('http://betrayed_phone/newMessageSubmit', JSON.stringify({
          number: escapeHtml($("#newMessage-form #number").val()),
          message: escapeHtml($("#newMessage-form #message").val())
      }));
      $("#newMessage-form #number").prop('disabled', true);
      $("#newMessage-form #message").prop('disabled', true);
      setTimeout(function(){
        $("#newMessage-form #number").prop('disabled', false);
        $("#newMessage-form #message").prop('disabled', false);
        $("#newMessage-form #number").val('');
        $("#newMessage-form #message").val('');
        closeAll();
        openMain();
      }, 500);
  });

  $(".btnAddContact").click(function(e){
      e.preventDefault();
      var escapedName = $("#newContact-form #name").val();

      var clean = escapedName
      $.post('http://betrayed_phone/newContactSubmit', JSON.stringify({
          name: clean,
          number: escapeHtml($("#newContact-form #number").val()).replace(/\s/g, '')
      }));
      $("#newContact-form #name").prop('disabled', true);
      $("#newContact-form #number").prop('disabled', true);
      $("#newContact-form #submit").css('display', 'none');
      setTimeout(function(){
        $("#newContact-form #name").prop('disabled', false);
        $("#newContact-form #number").prop('disabled', false);
        $("#newContact-form #name").val('');
        $("#newContact-form #number").val('');
        $("#newContact-form #submit").css('display', 'block');
        closeAll();
        openContacts();
      }, 500);
  });

  // On 'Esc' call close method
  document.onkeyup = function (data) {
    if (data.which == 27 ) {
      $.post('http://betrayed_phone/close', JSON.stringify({}));
    }
    if (gurgling == true) {
      searchGoogleUpdate()
    }

    if (twatting == true) {
      searchTwatterUpdate()
    }

    if (GPS == true) {
      searchGPSUpdate()
    }

    if (contacting == true) {
      searchContacts();
    }    

  };

  var curGPSLength = 0
  function searchGPSUpdate() {
    $(".whitebgGPS").show();
    var searchInput = $("#searchGPS").val();

    $(".whitebgGPS").find("div[class*='bubble-container']").each(function(i, el){  

      el.style.display = "block";
      curGPSLength = searchInput.length
      var dataSearchedHandle = el.children[0].innerHTML;
      var dataSearchedTitle = el.children[1].innerHTML;

      var reg = new RegExp('(.*)' + searchInput + '(.*)', 'ig');
      if (!reg.test(dataSearchedTitle) && !reg.test(dataSearchedHandle)) {

        el.style.display = "none";
      }

    });

  }



  var curTwatterLength = 0
  function searchTwatterUpdate() {
    $(".whitebg").show();
    var searchInput = $("#searchTwatter").val();

    $(".whitebg").find("div[class*='bubble-container']").each(function(i, el){  

      el.style.display = "block";
      curTwatterLength = searchInput.length
      var dataSearchedHandle = el.children[0].innerHTML;
      var dataSearchedTitle = el.children[1].innerHTML;
      var dataSearchedKeywords = el.children[2].innerHTML;
      var reg = new RegExp('(.*)' + searchInput + '(.*)', 'ig');
      if (!reg.test(dataSearchedTitle) && !reg.test(dataSearchedKeywords) && !reg.test(dataSearchedHandle)) {

        el.style.display = "none";
      }

    });

  }


  var curLength = 0
  function searchGoogleUpdate() {
    $(".googleHome").show();
    var searchInput = $("#searchGurgle").val();
    $(".googleHome").find("div[class*='googleResult']").each(function(i, el){  
      if ( searchInput.length === 0 ) {
      $("#searchGurgle").css("margin-left","7%")
      $("#searchGurgle").css("margin-top","4%")
        $(".googleHome").fadeOut(0);
        return
      }
      $(".googleHome").fadeIn(100);
      $("#searchGurgle").css("margin-left","7%")
      $("#searchGurgle").css("margin-top","4%")

      el.style.display = "block";

      curLength = searchInput.length
      var dataSearchedTitle = el.children[0].innerHTML;
      var dataSearchedKeywords = el.children[1].innerHTML;
      var dataSearchedDescription = el.children[2].innerHTML;
      var reg = new RegExp('(.*)' + searchInput + '(.*)', 'ig');
      if (!reg.test(dataSearchedTitle) && !reg.test(dataSearchedKeywords) && !reg.test(dataSearchedDescription)) {
        el.style.display = "none";
      }
    });
  }

  // Filter contact list based on search input
  function searchContacts() {
    var val = $("#searchContacts").val().trim();
    if (val && val.length > 0) {
      var query = val.toLowerCase().replace(/ /g, '').replace(/-/g, ''); // Lowercase, remove spaces and hyphens from search query
      // Hide all contacts
      $('.contactwrap').hide();
      // Loop through contacts and show ones that match the query
      $(".contacts-wrap").find("div[class*='contactwrap']").each(function(i, el){
        el.style.display = "none"; // Hide Contact

        var contactId = el.id.replace(/ /g, '').toLowerCase(); // Get name and number of current contact, remove spaces and make lowercase
        var reg = new RegExp('(.*)' + query + '(.*)', 'ig');
        if (reg.test(contactId)) { // Check if contact id includes the query
      		el.style.display = "block"; // Show valid contact
        }
      });
    } else {
      $('.contactwrap').show(); // Show all contacts
    }
  }

});
