$(document).ready(function(){
$('.right > .list-group-item').click(function(e) {
    e.preventDefault();
    $(this).addClass('active');
    $(this).siblings().removeClass('active');
    var id = $(this).attr('id');
    $('[aria-labelledby='+id+']').addClass('show active');
    $('[aria-labelledby='+id+']').siblings().removeClass('show active');
    $('left > .list-group-item, .active').removeClass('active');
});

$('.left > .list-group-item').click(function(e) {
    e.preventDefault();
    $(this).addClass('active');
    $(this).siblings().removeClass('active');
    var id = $(this).attr('id');
    $('[aria-labelledby='+id+']').addClass('show active');
    $('[aria-labelledby='+id+']').siblings().removeClass('show active');
    $('right > .list-group-item, .active').removeClass('active');
});
});
