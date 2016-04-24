$(document).ready(function() {

    $('#moveleft').click(function() {
        $('#textbox').animate({
        'marginLeft' : "0" //moves left
        });
        
        $('.toplam').animate({
        'marginLeft' : "100%" //moves right
        });
    });
    
    $('#moveright').click(function() {
        $('#textbox').animate({
        'marginLeft' : "50%" //moves right
        });
        
        $('.toplam').animate({
        'marginLeft' : "0" //moves right
        });
    });
    
});