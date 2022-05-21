$(function () {
  window.addEventListener(
    'message',
    function (event) {
      if (event.data.action == 'updateJob') {
        $('#praca').html(event.data.praca);
      }

      switch (event.data.action) {
        case 'toggle':
          if (event.data.state == true) {
            //$('#wrap').css('-webkit-animation-name', 'backInUp');
            $('#wrap').css('display', 'block');
          } else {
            //$('#wrap').css('-webkit-animation-name', 'backOutDown');
            $('#wrap').css('display', 'none');
          }
          break;

        case 'updateId':
          $('#server_uptime').html(event.data.id);
          break;

        case 'close':
          //$('#wrap').css('-webkit-animation-name', 'fadeOutDown');
          $('#wrap').css('display', 'none');
          break;
        case 'updatePlayerJobs':
          var jobs = event.data.jobs;

          $('#player_count').html(jobs.player_count);

          if (jobs.ems > 0) {
            // if (jobs.ems < 3) {
            //   $('#ems').html('<span style="color: orange">Max 2</span>');
            // } else {
            //   $('#ems').html('<span style="color: green">Min 2</span>');
            // }
            $('#ems').html(
              '<span style="color: green">' + jobs.ems + '</span>'
            );
          } else {
            $('#ems').html('<span style="color: red">0</span>');
          }

          if (jobs.police > 0) {
              $('#police').html('<span style="color: green">'+jobs.police+'</span>');
          } else {
            $('#police').html('<span style="color: red">0</span>');
          }

          if (jobs.mechanik2 > 0) {
            // if (jobs.mechanik < 3) {
            //   $('#mechanik').html('<span style="color: orange">Max 2</span>');
            // } else {
            //   $('#mechanik').html('<span style="color: green">Min 2</span>');
            // }
            $('#mechanik2').html(
              '<span style="color: green">' + jobs.mechanik2 + '</span>'
            );
          } else {
            $('#mechanik2').html('<span style="color: red">0</span>');
          }

          if (jobs.doj) {
            // $('#doj').html('<span style="color: green">Tak</span>');
            $('#doj').html(
              '<span style="color: green">' + jobs.doj + '</span>'
            );
          } else {
            $('#doj').html('<span style="color: red">0</span>');
          }

          if (jobs.cardealer) {
            // $('#cardealer').html('<span style="color: green">Tak</span>');
            $('#cardealer').html(
              '<span style="color: green">' + jobs.cardealer + '</span>'
            );
          } else {
            $('#cardealer').html('<span style="color: red">0</span>');
          }

          break;
        default:
          break;
      }
    },
    false
  );
});
