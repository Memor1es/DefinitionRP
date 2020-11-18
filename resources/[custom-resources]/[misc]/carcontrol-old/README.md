# Dependencies

# Installation
- Place folder in resources.
- start carcontrol in server.cfg

- Make sure you set your order number in the config.lua
- Once your server has started, the mod will request authorization.
- It can take up to 24 hours for the authorization to be approved, so please be patient.
- We recommend disabling the mod once authorization has been requested, and you're waiting for approval.

# Usage
Press backspace to toggle the UI.
The hotkey for opening the UI is found in the config.lua, while the key to close the UI is found in the carcontro.html file:
  
  document.onkeyup = function (data) {
    if (data.which == 8) { // backspace key
      $.post('http://carcontrol/close', JSON.stringify({}));
    }
  };