$(function () {
  window.addEventListener(
    'message',
    function (event) {
      switch (event.data.action) {
        case 'updatecam':
          $('#wrap').show();
          $('#player').html(event.data.odznaka);
          $('#agency').html(event.data.napis);
          break;
        case 'closecam':
          $('#wrap').hide();
          break;

        default:
          break;
      }
    },
    false
  );
});

$(function () {
  setTimeout(() => {
    console.log('Start');
  }, 5000);

  var d, h, m, s, animate;
  /*const monthNames = [
    'JANUARY',
    'FEBRUARY',
    'MARCH',
    'APRIL',
    'MAY',
    'JUNE',
    'JULY',
    'AUGUST',
    'SEPTEMBER',
    'OCTOBER',
    'NOVEMBER',
    'DECEMBER',
  ];*/
  const monthNames = [
    'STYCZEŃ',
    'LUTY',
    'MARZEC',
    'KWIECIEŃ',
    'MAJ',
    'CZERWIEC',
    'LIPIEC',
    'SIERPIEŃ',
    'WRZESIEŃ',
    'PAŹDZIERNIK',
    'LISTOPAD',
    'GRUDZIEŃ',
  ];

  function init() {
    d = new Date();
    h = d.getHours();
    m = d.getMinutes();
    s = d.getSeconds();
    t = d.toLocaleString('pl', { timeZoneName: 'short' }).split(' ').pop();
    clock();
    day = d.getDate();
    month = d.getMonth();
    year = d.getFullYear();
  }

  function clock() {
    s++;
    if (s == 60) {
      s = 0;
      m++;
      if (m == 60) {
        m = 0;
        h++;
        if (h == 24) {
          h = 0;
        }
      }
    }
    $('sec', s);
    $('min', m);
    $('hr', h);
    $('tz', t);
    $('day', day);
    $('year', year);
    $('month', monthNames[month]);
    animate = setTimeout(clock, 1000);
  }

  function $(id, val) {
    if (val < 10) {
      val = '0' + val;
    }
    document.getElementById(id).innerHTML = val;
  }

  window.onload = init;
});
