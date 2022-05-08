<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>Asiakkaat</title>
</head>
<body>
	<table id="listaus">
		<thead>	
			<tr>
			<th colspan="5" class="oikealle"><span id="uusiAsiakas">Lis�� uusi asiakas</span></th>
			</tr>
			<tr>
				<th colspan="3" class="oikealle">Hakusana:</th>
				<th><input type="text" id="hakusana"></th>
				<th><input type="button" id="hae" value="Hae"></th>
			</tr>		
			<tr>
				<th>Etunimi</th>
				<th>Sukunimi</th>
				<th>Puhelin</th>
				<th>Sposti</th>
				<th>&nbsp</th>				
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
<script>
$(document).ready(function(){	
	
	$("#uusiAsiakas").click(function(){
		document.location="lisaaasiakas.jsp";
	});
	
	$(document.body).on("keydown", function(event){
		  if(event.which==13){ //Enteriï¿½ painettu, ajetaan haku
			  haeTiedot();
		  }
	});	
	$("#hae").click(function(){	
		haeTiedot();
	});
	$("#hakusana").focus();//viedï¿½ï¿½n kursori hakusana-kenttï¿½ï¿½n sivun latauksen yhteydessï¿½
	haeTiedot();
});

function haeTiedot(){	
	$("#listaus tbody").empty();
	//$.getJSON on $.ajax:n alifunktio, joka on erikoistunut jsonin hakemiseen. Kumpaakin voi tï¿½ssï¿½ kï¿½yttï¿½ï¿½.
	//$.getJSON({url:"asiakkaat/"+$("#hakusana").val(), type:"GET", success:function(result){
	$.ajax({url:"asiakkaat/"+$("#hakusana").val(), type:"GET", dataType:"json", success:function(result){
		$.each(result.asiakkaat, function(i, field){  
        	var htmlStr;
        	htmlStr+="<tr id='rivi_"+field.asiakas_id+"'>"; 
        	htmlStr+="<td>"+field.etunimi+"</td>";
        	htmlStr+="<td>"+field.sukunimi+"</td>";
        	htmlStr+="<td>"+field.puhelin+"</td>";
        	htmlStr+="<td>"+field.sposti+"</td>"; 
        	htmlStr+="<td><a href='muutaasiakas.jsp?asiakas_id="+field.asiakas_id+"'>Muuta</a>&nbsp"; 
        	htmlStr+="<span class='poista' onclick=poista("+field.asiakas_id+",'"+field.etunimi+"','"+field.sukunimi+"')>Poista</span></td>"; 
        	htmlStr+="</tr>";
        	$("#listaus tbody").append(htmlStr);
        });
    }});	
}
function poista(asiakas_id, etunimi, sukunimi) {
	if (confirm("Poista asiakas " + etunimi + " " + sukunimi + "?")) {
		$.ajax({url:"asiakkaat/"+asiakas_id, type:"DELETE", dataType:"json", success:function(result){ 
	        if(result.response==0){
	        	$("#ilmo").html("Asiakkaan poisto ep�onnistui.");
	        }else if(result.response==1){
	        	$("#rivi_"+asiakas_id).css("background-color", "red"); 
	        	alert("Asiakkaan " + etunimi +" "+ sukunimi +" poisto onnistui.");
				haeTiedot();        	
			}
	    }});
		
	}
}

	
	
</script>
</body>
</html>