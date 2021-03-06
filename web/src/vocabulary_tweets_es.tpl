<html>
<head>
  <title>Translate {{params['lang_name']}} words to English</title>
  <link rel="stylesheet" href="/static/main.css" type="text/css" />
    
  <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"></script>

  <!--script type="text/javascript" src="/static/mturk.js"></script-->
  <script type="text/javascript" src="/static/jquery.cookie.js"></script>
  
  
</head>
<body>
  <script>
	var HITtype="{{params['hit_type']}}";
	var ip="{{params['ip']}}";
	
 $.getJSON("http://api.ipinfodb.com/v3/ip-city/?key={{params["ipinfodb_key"]}}&ip="+ip+"&format=json&callback=?",function(data) {
    //alert("Location Data: " + data['cityName']+", "+data['regionName']);
	$("#debug").html($("#debug").html()+"city: "+data['cityName']+"<br/>");
	$("#debug").html($("#debug").html()+"region: "+data['regionName']+"<br/>");
	
	$("#ip").val(data['ipAddress']);
	$("#city").val(data['cityName']);
	$("#region").val(data['regionName']);
	$("#country").val(data['countryName']);
	$("#zipcode").val(data['zipCode']);
	$("#lat").val(data['latitude']);
	$("#lng").val(data['longitude']);
	
	//countryCode, countryName, zipCode, 
	/* Format of JSON response from IP Info DB
	{
		"statusCode" : "OK",
		"statusMessage" : "",
		"ipAddress" : "74.125.45.100",
		"countryCode" : "US",
		"countryName" : "UNITED STATES",
		"regionName" : "CALIFORNIA",
		"cityName" : "MOUNTAIN VIEW",
		"zipCode" : "94043",
		"latitude" : "37.3956",
		"longitude" : "-122.076",
		"timeZone" : "-08:00"
	}
	*/
    }); 


	//disable/enable form submit (when input is valid)
	function form_valid(param)
	{
		if (param){
			$("#submitbutton").removeAttr('disabled');
			$("#form_validation").hide();
		}
		else{
			$("#submitbutton").attr("disabled", "disabled");
			$("#form_validation").show();
		}
		
	};
	
	//function with form validation for translation of 10 words
	function validate_form(){
		form_valid(true);

		for (i=0;i<=10;i++){
			if ($("#word"+i+"in").val()=="") {
			
			if ($("#check"+i)[0].checked && $("#reason"+i).val()=="") {
				form_valid(false);
				break;
			}
			else if (!$("#check"+i)[0].checked)
			{
				form_valid(false);
				break;
				
			};
		};
			
		};
		
		//alert("validation");
		
	};
	


	//add show/hide events to words/help (3 sentences with word usage)
	function add_wordhandler(i){
		$("#word"+i+"in").focus(function(){
			$("#word"+i+"help").show();
			
		});
		$("#word"+i+"in").blur(function(){
			$("#word"+i+"help").hide();
			validate_form();
		});
		$("#word"+i+"in").keypress(function(){
			validate_form();
		});

		$("#check"+i).change(function(){
			validate_form();
		});
		$("#check"+i).click(function(){
			validate_form();
		});
		

		$("#reason"+i).change(function(){
			validate_form();
		});
		$("#reason"+i).blur(function(){
			validate_form();
		});		
	};

	function add_canttranslatehandler(i){
		$("#check"+i).click(function(){
			$("#reason"+i+"div").toggle();
		});
			
		
	};


 $.getJSON("/tweets?hitId={{params['hitid']}}", function(data) {
	for (word in data["words"]){
		//alert(data["words"][word]["word"]);
		$("#word"+word).html(data["words"][word]["word"]);
		
		c="";
		if ((word%2)?false:true){
			//even
			c=' class="even" ';
		}
		else{
			c=' class="odd" ';
		}
		
		options="<select name='reason"+word+"' id='reason"+word+"'>"+
		  "<option value=''>Select a reason, you can't translate this word</option>"+
		  "<option value='notaword'>Not a word (gibberish/HTML formatting/special characters)</option>"+
		  "<option value='notaword'>Word is too obscure to translate</option>"+
		  "<option value='englishword'>English word</option>"+
		  "<option value='other'>Other</option>"+
		"</select>";

		//html='<tr><td id="word'+word+'">'+data["words"][word]["word"]+'</td><td><input id="word'+word+'in" type="text" name="word'+word+'" size="50"></input><br/><div id="word'+word+'help" style="display:none">help</div></td></tr>';
		html='<tr '+c+' ><td id="word'+word+'"><b>'+data["words"][word]["word"]+'</b><!--img src="/static/images/{{params['lang']}}/word/'+data["words"][word]["word_id"]+'.png"/--></td><td><input id="word'+word+'in" type="text" name="word'+word+'-'+data["words"][word]["word_id"]+'" size="50"></input></td><td width="400px"><label for="check'+word+'">Can\'t translate</label> <input type="checkbox" name="check'+word+'" id="check'+word+'"></input> <div id="reason'+word+'div" style="display:none;"> '+options+'</div></td></tr>';
		html=html+'<tr><td></td><td colspan="2"><div id="word'+word+'help" style="display:none"><img src="/static/images/{{params['lang']}}/sentences/'+data["words"][word]["word_id"]+'.png"/></div></td></tr>';
		//alert(html);
		
		$("#word_table").html($("#word_table").html()+html);


	}
	for (i=0;i<10;i++){
		add_wordhandler(i);
		add_canttranslatehandler(i);
	}


    }); 

    
 $.getJSON("/ip", function(json) {
    //alert("JSON Data: " + json.ip);
	$("#debug").html($("#debug").html()+"IP: "+json.ip+"<br/>");
    }); 

		function getParameterByName(name)
		{
		  name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
		  var regexS = "[\\?&]" + name + "=([^&#]*)";
		  var regex = new RegExp(regexS);
		  var results = regex.exec(window.location.href);
		  if(results == null)
		    return "";
		  else
		    return decodeURIComponent(results[1].replace(/\+/g, " "));
		};


 		$(document).ready(function() {
			// Handler for .ready() called.
			//alert(getParameterByName("assignmentId"));
		    //alert(getParameterByName("hitId"));
              //alert("?");
              //debugger;
			var assignmentId=getParameterByName("assignmentId");
			
			if (assignmentId=="ASSIGNMENT_ID_NOT_AVAILABLE" || assignmentId=='')
			{
				$("#preview_panel").show();
				$("#submitbutton").hide();
			}


			$("#assignmentId").val(getParameterByName("assignmentId"));
			$("#hitId").val(getParameterByName("hitId"));
			//alert(getParameterByName("assignmentId"));
			
			$("#debug").html($("#debug").html()+"assignmentId: "+getParameterByName("assignmentId")+"<br/>");
			$("#debug").html($("#debug").html()+"hitId: "+getParameterByName("hitId")+"<br/>");


			$('#mainform').submit(function(){
			  // your validation code
			});
			
			
			
			

		});   
   
  </script>
  
  <h1>Translate {{params['lang_name']}}  into English</h1>
  <table width="100%">
  	<tr>
     	<td width="*">
  <div id="instructions">
	<p>This HIT is only for people who speak both {{params['lang_name']}} and English.</p>
	            <p>Please translate each of the 10 words shown below.   When you click in the text area, you will be shown some examples of the words used in sentences.  You only need to translate the word itself, not the whole sentences.  If you are unable to translate one of the words, you should use checkbox on the right to mark those words and pick a reason why you can't translate it using the drop down list.</p>

					    <p>If any of the words has more than one possible translation, just enter the one that you think is the most common.</p>
						<p>IMPORTANT: Please DO NOT simply type all the words into Google translate or another online translation tool.  The goal of this HIT is to improve the quality of translation systems using knowledge from bilingual individuals.  If you do not know either of the languages then do not do this HIT.</p>
						
						<p>Translating proper nouns like names or places is a little different than other words.  For words like
							<br/><img src="/static/images/support/{{params['lang']}}.png"/>
							<br/>
							You should enter Barack Obama and Australia as the translations.</p>
						
    <a href="" id="hide_instructions">hide instructions</a>
  </div>
  <div id="instructions2"  style="display:none;">
    <a  href="" id="show_instructions">show instructions</a>
  </div>
	<br/>

	<div id="preview_panel" style="display:none;">
		This is just a preview! You MUST accept the HIT before you can submit the results.
	</div>


     	</td>
		<td width="250px" rowspan="2" valign="top">
  			%include templates/consent.tpl
  		</td>
  		
  	</tr>
  	<tr>
  		<td valign="top" >
  			<!-- This POST method is posting to the sandbox worker site-->
              <form id="mainform" method="GET" action="http://workersandbox.mturk.com/mturk/externalSubmit">
              <!-- This POST method is posting to the production worker site-->
              <!--<form method="POST" action="http://www.mturk.com/mturk/externalSubmit">-->
	              <input type="hidden" id="assignmentId" name="assignmentId" value=""/>
	              <input type="hidden" id="hitId" name="hitId" value=""/>
	              <input type="hidden" id="ip" name="ip" value=""/>
	              <input type="hidden" id="city" name="city" value=""/>
	              <input type="hidden" id="region" name="region" value=""/>
	              <input type="hidden" id="country" name="country" value=""/>
	              <input type="hidden" id="zipcode" name="zipcode" value=""/>
	              <input type="hidden" id="lat" name="lat" value=""/>
	              <input type="hidden" id="lng" name="lng" value=""/>
              

				<div id="user_survey">
		  			%include templates/foreignenglishspeakersurvey.tpl lang_name=params['lang_name']
				</div>

				<div id="words_panel">
					<h3>Translate the individual words on the left</h3>
					<table id="word_table">
					</table>
				</div>

				<input id="submitbutton" type="submit" value="Done!" disabled="disabled"/>
				<div id="validation_text">
					All ten translation should be completed before this HIT can be submitted.
				</div>
				
  			</form>
  			
  			
  			
<div id="debug" style="display:none;">
	<h3>Debug:</h3>
</div>
  		</td>
  	</tr>
  </table>


%include templates/instructions_js
</body>
</html>