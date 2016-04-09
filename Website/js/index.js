$(document).ready(function() {

	var location;
	$('.location').change(function(){
		location = $(this).val();
		console.log(location);
		if(location === "Lagos"){
			$(".date1").html("<option value='June 23rd-24th'>June 23rd-24th</option><option value='July 28th-29th'>July 28th-29th</option>");
		}
		else if(location === "Abuja"){
			$(".date1").html("<option value='June 24th-26th'>June 24th-26th</option>");
		}
		else if(location === "Ibadan"){
			$(".date1").html("<option value='July 30th-31st'>July 30th-31st</option>");
		}
		else if(location === "Port Harcourt"){
			$(".date1").html("<option value='August 27th-28th'>August 27th-28th</option>");
		}else{
			$(".date1").html("<option value=''> -select date- </option>");
		}
	});

	$('.formid').validate({
            rules: {
                "name": {
                    required: true,
                    minlength: 5
                },
                "email": {
                    required: true,
                    email: true
                },
                "location": {
                    required: true
                },
                "date1": {
                    required: true
                },
                "industry": {
                    required: true
                }
            },
            submitHandler: function() {
                var name = $('.name').val();
                var email = $('.email').val();
                var location = $('.location').val();
                var date = $('.date1').val();
                var industry = $('.industry').val();

                $.ajax({
                    url: 'processor.php',
                    type: 'POST',
                    data: {email: email, location:location, name: name, date:date, industry:industry},
                    dataType: " html"
                }).done(function(msg) {
                    if(msg == 2){

                    	$('form').children('p.label').html('');
                    	$('form').html("<p class='label label-success' style='background-color: transparent !important; color: black !important; display: block !important; font-size: 2.2rem !important; margin: 12rem auto !important; width: 100% !important; font-weight: 300;'>Thank you for applying, we will get back to you.</p><br>");

                    }else if(msg == 1){

                    	$('form').children('p.label').html(''); 
                    	
                        $('form').prepend("<p class='label label-danger'>You have already applied.</p><br>");

                    }else{

                    	$('form').children('p.label').html(''); 

                        $('form').prepend("<p class='label label-danger'>" + msg + "</p><br>");
                    }

                    console.log(msg);

                }).fail(function() {
                    console.log("error");
                })
            }

           
    });

});
	
