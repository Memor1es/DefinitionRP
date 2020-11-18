function calcTime(offset) {
		d = new Date();
		utc = d.getTime() + (d.getTimezoneOffset() * 60000);
		nd = new Date(utc + (3600000*offset));
		return nd;
	}

function time_ago(time) {

  switch (typeof time) {
    case 'number':
      break;
    case 'string':
      time = +new Date(time);
      break;
    case 'object':
      if (time.constructor === Date) time = calcTime(-8);
      break;
    default:
      time = +calcTime(-8);
  }
  var time_formats = [
    [60, 'seconds', 1], // 60
    [120, '1 minute ago', '1 minute from now'], // 60*2
    [3600, 'minutes', 60], // 60*60, 60
    [7200, '1 hour ago', '1 hour from now'], // 60*60*2
    [86400, 'hours', 3600], // 60*60*24, 60*60
    [172800, 'Yesterday', 'Tomorrow'], // 60*60*24*2
    [604800, 'days', 86400], // 60*60*24*7, 60*60*24
    [1209600, 'Last week', 'Next week'], // 60*60*24*7*4*2
    [2419200, 'weeks', 604800], // 60*60*24*7*4, 60*60*24*7
    [4838400, 'Last month', 'Next month'], // 60*60*24*7*4*2
    [29030400, 'months', 2419200], // 60*60*24*7*4*12, 60*60*24*7*4
    [58060800, 'Last year', 'Next year'], // 60*60*24*7*4*12*2
    [2903040000, 'years', 29030400]// 60*60*24*7*4*12*100*20, 60*60*24*7*4*12*100
  ];
  var seconds = (+calcTime(-8) - time) / 1000,
    token = 'make',
    list_choice = 1;

  if (seconds == 0) {
    return 'Right now'
  }
  if (seconds < 0) {
    seconds = Math.abs(seconds);
    token = '';
    list_choice = 2;
  }
  var i = 0,
    format;
  while (format = time_formats[i++])
    if (seconds < format[0]) {
      if (typeof format[2] == 'string')
        return format[list_choice];
      else
        return token + ' ' + Math.floor(seconds / format[2]) + ' ' + format[1] + ' '
    }
  return time;
}