window.addEventListener('message', function(event) {

	var data = event.data;
	
	switch(data.action) {
		case 'gopro':
			if (data.state) {
				$('#gopro').fadeIn()
			} else { 
				$('#gopro').fadeOut()
			}
		break;
	}
	

});
