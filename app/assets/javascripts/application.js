// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require_tree .
//= require underscore
//= require gmaps/google
//= require jquery
//= require bootstrap-sprockets
//= require moment
//= require bootstrap-datetimepicker
//= require moment/ja.js
//= require markerclusterer_packaged






  function showResult(result){

      if ( result.total_hit_count > 0 ) {
        var res = '';

        alert( result.total_hit_count + '件の結果が見つかりました。\n' );
  //      alert( result.hit_per_page + '取得件数\n' );
        for ( var i in result.rest ){
  //          res += result.rest[i].name + ' ' + result.rest[i].url + ' ' + result.rest[i].access.line + ' ' + result.rest[i].access.station + ' ' + result.rest[i].access.walk + '分\n';
            res += '<input type="button" value="追加" class="add btn btn-primary" />'
                + '<a href=' + result.rest[i].url
                + '>' + result.rest[i].name + '</a>'
                + '最寄駅：'
                + result.rest[i].access.station
                + '距離：'
                + result.rest[i].access.walk
                + '分\n<br>'
                + '<input type="hidden" name="userid" value=' + result.rest[i].latitude + '>'
                + '<input type="hidden" name="userid" value=' + result.rest[i].longitude + '>'

        }
  //      console.log(res);
  //      console.log("生データ");
        console.log(result);
        $(".view").html(res);
      } else {
        alert( '検索結果が見つかりませんでした。' );
      }
    }

  $(document).on('click', '.js--apply', function(){

    var url = 'http://api.gnavi.co.jp/RestSearchAPI/20150630/?callback=?';

    var range = $("input[name='range']:checked").val();
    //alert(range)

    var params = {
      keyid: 'cae5974528b21caa3660751869674b23',
      format: 'json',
      latitude: 35.705518,
      longitude: 139.649267,
      range: range,
      hit_per_page: 200
    };

  //  params.keyid = $('.js--key').val();


$.getJSON(
  url,
  params,
  function(result){
  showResult(result);
});
  });




// プランの開始日の設定(datetimepicker)
var data = {'data-date-format': 'yyyy-MM-dd' };
$(function(){
  $('.startdatepicker').attr(data);
  $('.startdatepicker').datetimepicker({
    locale: 'ja',
    format: 'YYYY/MM/DD'
  });
});

// プランの終了日の設定(datetimepicker)
var data = {'data-date-format': 'yyyy-MM-dd' };
$(function(){
  $('.enddatepicker').attr(data);
  $('.enddatepicker').datetimepicker({
    locale: 'ja',
    format: 'YYYY/MM/DD',
    useCurrent: false
  });
});

// 開始日 > 終了日　は入力できないように表示制御(datetimepicker)
$(function(){
  $('.startdatepicker').on("dp.change", function (e) {
     $('.enddatepicker').data("DateTimePicker").minDate(e.date);
   });
   $('.enddatepicker').on("dp.change", function (e) {
     $('.startdatepicker').data("DateTimePicker").maxDate(e.date);
   });
});


//alert("発火のタイミング");





//画像など全ての読み込みが完了した時点で発火される処理
$(window).load(function(){
  var min = $("#min").html();
//  alert(min);
  var max = $("#max").attr('class');
//  var max1=new Date(max);
//  max1.setDate(max1.getDate()+1);
//  alert(max);

  // 場所のFROMの設定(datetimepicker)
  var data = {'data-date-format': 'YYYY-MM-DD H:mm' };
  $(function(){
    $('.startdatetimepicker').attr(data);
    $('.startdatetimepicker').datetimepicker({
      minDate: min,
      maxDate: max,
      useCurrent: false,
      stepping: 5,
      sideBySide: true,
      locale: 'ja',
      format: 'YYYY-MM-DD H:mm'
    });
  });

  // 場所のTOの設定(datetimepicker)
  var data = {'data-date-format': 'YYYY-MM-DD H:mm' };
  $(function(){
    $('.enddatetimepicker').attr(data);
    $('.enddatetimepicker').datetimepicker({
      minDate: min,
      maxDate: max,
      useCurrent: false,
      stepping: 5,
      sideBySide: true,
      locale: 'ja',
      format: 'YYYY-MM-DD H:mm'
    });
  });

  // FROM > TO　は入力できないように表示制御(datetimepicker)
  //複数フォームあるが、一つ目のフォームにしか適用されていない。バグ(0901現在)
  //正直この処理は必要か微妙なところ
  // $(function(){
  //   $('.startdatetimepicker').on("dp.change", function (e) {
  //      $('.enddatetimepicker').data("DateTimePicker").minDate(e.date);
  //    });
  //   //  $('.startdatetimepicker').on("dp.hide", function (e) {
  //   //     $('.enddatetimepicker').data("DateTimePicker").toggle();
  //   //   });
  //    $('.enddatetimepicker').on("dp.change", function (e) {
  //      $('.startdatetimepicker').data("DateTimePicker").maxDate(e.date);
  //    });
  // });



　// 追加された場所をドラッグすることで、順序を変更できるようにする(jquery-ui sortable)
  $('#sortable').sortable({
    start: function(event, ui) {
      //alert(ui.item);
      ui.item.css("background-color", "orange");
    },
    stop: function(event, ui) {
    $('#sortable').css("background-color", "white");
    ui.item.css("background-color", "#FFFFDD");
    id = $("#plan_id").val();
    var post ={
      //row: $(this).sortable( 'serialize'), viewをrow_1,row_2のようにする必要がある
      row: $(this).sortable( 'toArray'),
      id: id
    };
    jQuery.post(
      '/places/reorder',
      post,
      function(data){
    //    alert(data);
        callbacks(data);
        },
      'json');
    },
    //helper: "clone",
    cursor: 'move',
    //forcePlaceholderSize: true,
    opacity: 0.8
    //revert: true
  });

  $('#sortable').disableSelection();


  $('#sortable').bind('sortstop', function (e, ui) {
    // ソートが完了したら実行される。
    var rows = $('#sortable .route');
    //alert(rows.length);
    $('.hidden_number').text("");
    console.log(rows);
    for (var i = 0, rowTotal = rows.length; i < rowTotal; i += 1) {
        $($('.route')[i]).text(i + 1);
        $($('.hidden_number')[i]).attr('id', i);
    }
})



// FROMとTOをajaxで更新する
//　本当は値のchangeイベントでやるべきだが、datapickだとうまくいかないため、暫定的な対応
$(".testid").focusout(function(e) {
  id = $(this).parent().parent().parent().attr('id');
  var tagname = $(this).attr('name')
  if (tagname == "place[from]"){
      //alert(tagname);
      var post = {
          place:{
            from: e.target.value,
          //  to: e.target.value,
            id :id
          }
        }
  } else {
      var post = {
          place:{
            //  from: e.target.value,
            to: e.target.value,
            id :id
          }
        }
      }
  jQuery.post(
    '/plans/datetime',
    post,
    function(data){
    //  alert(data);
      },
    'text');
});

// $("tr").mouseover(function(){
//   alert($(this));
// })

//window.open('example.html', 'mywindow2', 'width=400, height=300, menubar=no, toolbar=no, scrollbars=yes');
//window.prompt("ユーザー名を入力してください", "Uese Name")


//確認画面に遷移する前に、時間の項目が全て入力されていることを確認する。
//未入力の項目がある場合、確認画面には遷移しない。
document.getElementById( 'confirm' ).onclick = function( e ){
  value = $(".testid")
  flg = true;
//console.log(value);
 for (var i = 0; i < value.length; i++) {
//     console.log(value[i].value);
   if (value[i].value == "" )  {
     flg = false;
   };
 };
    if (!flg){
      alert("未入力の項目があります")
      return flg;
    }
};




});





function callbacks(data){
//  alert(data);
//ここから
//alert(data["hash"]);
//alert(data.point);

handler = Gmaps.build('Google');
defo = new google.maps.LatLng( 39.0686606 , 141.3507552 );
handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){

  markers = handler.addMarkers(data.hash);
  handler.bounds.extendWith(markers);
  handler.fitMapToBounds();
  handler.getMap().setZoom(7);
  handler.map.centerOn(data.point[0]);
});


 //場所を線で結ぶ処理（道に沿った線。時間も算出できる）
 rendererOptions = {
 draggable: true,
 preserveViewport: false,
 suppressMarkers: true
 };
 var directionsDisplay =
   new google.maps.DirectionsRenderer(rendererOptions);
 var directionsService =
   new google.maps.DirectionsService();



 var wayPoints = [];

//⬇︎関数として定義し直す
//クリックにバインドしていたのを常に実行するようにした
//中身は全く一緒

 directionsDisplay.setMap(handler.getMap());
//	alert("始まるよ");
 google.maps.event.addListener(directionsDisplay,
   'directions_changed', function(){
 });
//経由ポイント@始点と終点を除く
poli = [];
point = data.point;
//alert(point.length);
 for (var i = 0; i < point.length; i++) {
//alert(point[i][1]);
//alert(point[i][0]);
//alert(i);
 poli.push(new google.maps.LatLng( point[i][0], point[i][1] ));
};
 for (var i = 1; i < poli.length-1; i++) {
     wayPoints.push({
       location: poli[i],
       stopover: true
     });
 }
 calcRoutess();
//⬆︎ここまでは関数化する

 //経路（道に沿った）や時間を算出する
 document.getElementById( 'create_routes_time' ).onclick = function( e ){
  directionsDisplay.setMap(handler.getMap());
//	alert("始まるよ");
  google.maps.event.addListener(directionsDisplay,
    'directions_changed', function(){
  });
 //経由ポイント@始点と終点を除く
 poli = [];
 point = data.point;
 //alert(point.length);
	for (var i = 0; i < point.length; i++) {
 //alert(point[i][1]);
 //alert(point[i][0]);
 //alert(i);
	poli.push(new google.maps.LatLng( point[i][0], point[i][1] ));
};
//		alert(poli);
  for (var i = 1; i < poli.length-1; i++) {
      wayPoints.push({
        location: poli[i],
        stopover: true
      });
  }
  calcRoutess();
 }



 function calcRoutess() {
  var request = {
  origin: poli[0],
  destination: poli[poli.length-1],
  travelMode: google.maps.DirectionsTravelMode.DRIVING,
  unitSystem: google.maps.DirectionsUnitSystem.METRIC,
  waypoints: wayPoints,
  optimizeWaypoints: false,
  avoidHighways: false,
  avoidTolls: false
  };

  directionsDisplay.setPanel(document.getElementById('directions-result'));
  directionsService.route(request,
   function(response,status){
   if (status == google.maps.DirectionsStatus.OK){
     $('.hidden_number').text("");
		 for (var i = 0; i < response.routes[0].legs.length; i++) {
			$("#" + i).text("⬇︎" + Math.floor( response.routes[0].legs[i].duration.value / 60) + "分" + "(" + Math.floor(response.routes[0].legs[i].distance.value / 1000 )+ "Km)" );
		 	};
   directionsDisplay.setDirections(response);}
//	 alert(status);
   });
 }

//ここまで
}


window.onload = function(){
//マップを表示

//latlngは（緯度,経度）

//日本
var latlng1 = new google.maps.LatLng(36, 135);
//日本
var latlng2 = new google.maps.LatLng(36, 135);
//鳥取県
var latlng3 = new google.maps.LatLng(35.5, 134);

//日本
var latlng4 = new google.maps.LatLng(36, 135);
//日本
var latlng5 = new google.maps.LatLng(36, 135);
//鳥取県
var latlng6 = new google.maps.LatLng(35.5, 134);

//鳥取県
var latlng7 = new google.maps.LatLng(35.5, 134.1);

//鳥取県
var latlng8 = new google.maps.LatLng(35.5, 134.1);

//デフォルト（鳥取）
var latlng9 = new google.maps.LatLng(35.5, 134.1);


var myOptions1 = {
	zoom: 4,
	center: latlng1,
	mapTypeId: google.maps.MapTypeId.ROADMAP
};

var myOptions2 = {
	zoom: 4,
	center: latlng2,
	mapTypeId: google.maps.MapTypeId.ROADMAP
};

var myOptions3 = {
	zoom: 10,
	center: latlng3,
	mapTypeId: google.maps.MapTypeId.ROADMAP
};

var myOptions4 = {
	zoom: 4,
	center: latlng4,
	mapTypeId: google.maps.MapTypeId.ROADMAP,
  draggable: false
};
var myOptions5 = {
	zoom: 4,
	center: latlng5,
	mapTypeId: google.maps.MapTypeId.ROADMAP,
  scrollwheel: false
};
var myOptions6 = {
	zoom: 4,
	center: latlng6,
	mapTypeId: google.maps.MapTypeId.ROADMAP
};

var myOptions7 = {
	zoom: 10,
	center: latlng7,
	mapTypeId: google.maps.MapTypeId.ROADMAP
};

var myOptions8 = {
	zoom: 8,
	center: latlng8,
	mapTypeId: google.maps.MapTypeId.ROADMAP
};

var myOptions9 = {
	zoom: 8,
	center: latlng9,
	mapTypeId: google.maps.MapTypeId.ROADMAP
};


// マーカーのインスタンスを配列で定義する
var markers = [] ;



//マップのインスタンスを作成する
var map1 = new google.maps.Map(document.getElementById("googlemaps1"), myOptions1);
var map2 = new google.maps.Map(document.getElementById("googlemaps2"), myOptions2);
var map3 = new google.maps.Map(document.getElementById("googlemaps3"), myOptions3);
var map4 = new google.maps.Map(document.getElementById("googlemaps4"), myOptions4);
var map5 = new google.maps.Map(document.getElementById("googlemaps5"), myOptions5);
var map6 = new google.maps.Map(document.getElementById("googlemaps6"), myOptions6);
var map7 = new google.maps.Map(document.getElementById("googlemaps7"), myOptions7);
var map8 = new google.maps.Map(document.getElementById("googlemaps8"), myOptions8);
var map9 = new google.maps.Map(document.getElementById("googlemaps9"), myOptions9);

// マーカーのインスタンスを作成する
markers[0] = new google.maps.Marker({
	map: map6 ,
	position: new google.maps.LatLng( 35.792621 , 139.806513 ) ,
}) ;




/* イベントの設定 (マーカー設定) */
document.getElementById( 'maps7_markeranime' ).onclick = function( e )
{
  /* 関係ない動作を無効化 */
  var e = e || window.event ;
  e.preventDefault() ;
  e.stopPropagation() ;


  markers[1] = new google.maps.Marker({
  	map: map7 ,
  	position: new google.maps.LatLng( 35.5, 134.25 ) ,
  }) ;

  /* マーカーにアニメーションを適用する */
//  markers[1].setAnimation( google.maps.Animation.DROP ) ;
}


/* イベントの設定 (マーカー削除) */
document.getElementById( 'maps7_markerdelete' ).onclick = function( e )
{
  /* 関係ない動作を無効化 */
  var e = e || window.event ;
  e.preventDefault() ;
  e.stopPropagation() ;
  markers[1].setMap(null)
}


/* イベントの設定 (鳥取市をマーカー) */
document.getElementById( 'maps8_marker_tottori' ).onclick = function( e )
{
  /* 関係ない動作を無効化 */
  var e = e || window.event ;
  e.preventDefault() ;
  e.stopPropagation() ;


  markers[2] = new google.maps.Marker({
  	map: map8 ,
  	position: new google.maps.LatLng( 35.5, 134.25 ) ,
    draggable: true ,
  }) ;

  /* マーカーにアニメーションを適用する */
  markers[2].setAnimation( google.maps.Animation.DROP ) ;
}

/* イベントの設定 (米子市をマーカー) */
document.getElementById( 'maps8_marker_yonago' ).onclick = function( e )
{
  /* 関係ない動作を無効化 */
  var e = e || window.event ;
  e.preventDefault() ;
  e.stopPropagation() ;


  markers[3] = new google.maps.Marker({
  	map: map8 ,
  	position: new google.maps.LatLng( 35.4, 133.31 ) ,
    draggable: true ,
  }) ;

  /* マーカーにアニメーションを適用する */
  markers[3].setAnimation( google.maps.Animation.DROP ) ;
}


// 線(Polyline)のインスタンスを格納する配列
var polylines = [] ;


/* イベントの設定 (米子市_鳥取市を結ぶ) */
document.getElementById( 'maps8_polylines_yonago_to_tottori' ).onclick = function( e )
{
  /* 関係ない動作を無効化 */
  var e = e || window.event ;
  e.preventDefault() ;
  e.stopPropagation() ;


  // 1つ目の線(Polyline)のインスタンスを作成する
  // [ new google.maps.Polyline() ]の引数にオプションオブジェクトを指定する
  polylines[0] = new google.maps.Polyline( {
  	map: map8 ,
  	path: [
  		new google.maps.LatLng( 35.5, 134.25 ) ,
  		new google.maps.LatLng( 35.4, 133.31 ) ,
  	] ,
  } ) ;
}

//ジオコーディングで追加した場所の位置情報を保持しておくための変数
var markerlist = Array();
var infowindows_list = Array();
var markerlist2 = Array();
j = 1
/* 入力フォームの値からマーカを作成*/
document.getElementById( 'geo' ).onclick = function( e )
{
  var geocoder = new google.maps.Geocoder();
  geocoder.geocode({
    'address': document.getElementById( 'address' ).value
  }, function(result, status){
    if (status == google.maps.GeocoderStatus.OK){
      map9.panTo(result[0].geometry.location);
      marker = new google.maps.Marker({
        map: map9 ,
        position: result[0].geometry.location ,
        title: document.getElementById( 'address' ).value + '--' + document.getElementById( 'comment' ).value ,
      }) ;
      markerlist.push(result[0].geometry.location);
      //console.log(markerlist);
alert(result[0].geometry.location)
      var infowindow=new google.maps.InfoWindow({
                      content: "場所：" + document.getElementById( 'address' ).value + "<br>"
                      + "登録者：" + "ユーザA(⭐️⭐️⭐️)" + "<br>"
                      + "コメント：" + document.getElementById( 'comment' ).value + "(ユーザA)",
                      position: result[0].geometry.location,
                  });
      google.maps.event.addListener(marker, 'click', function() {
                infowindow.open(map9);
            });
            infowindows_list.push(infowindow);
            markerlist2.push(marker);


						document.getElementById("point").appendChild(document.createTextNode(j));
            document.getElementById("point").appendChild(document.createTextNode(document.getElementById( 'address' ).value));
						var br = document.createElement('br');
						document.getElementById("point").appendChild(br);
						j　= j + 1;



    } else {
      alert("エラーです");
      alert(status);
    }
  });
}


// 追加した場所を線で結ぶ
document.getElementById( 'polylines_geo' ).onclick = function( e )
{
polylines[1] = new google.maps.Polyline( {
  map: map9 ,
  path: markerlist
} ) ;
}


//道に沿った経路をや、時間算出のオブジェクトを生成する
rendererOptions = {
draggable: true,
preserveViewport: false,
suppressMarkers: true
};
var directionsDisplay =
  new google.maps.DirectionsRenderer(rendererOptions);
var directionsService =
  new google.maps.DirectionsService();



var wayPoints = [];
//経路（道に沿った）や時間を算出する
document.getElementById( 'polylines_dis' ).onclick = function( e )
{
   directionsDisplay.setMap(map9);

 google.maps.event.addListener(directionsDisplay,
   'directions_changed', function(){
 });
//経由ポイント@始点と終点を除く
 for (var i = 1; i < markerlist.length-1; i++) {
     wayPoints.push({
       location: markerlist[i],
       stopover: true
     });
 }
 calcRoute();
}



function calcRoute() {
 var request = {
 origin: markerlist[0],
 destination: markerlist[markerlist.length-1],
 travelMode: google.maps.DirectionsTravelMode.DRIVING,
 unitSystem: google.maps.DirectionsUnitSystem.METRIC,
 waypoints: wayPoints,
 optimizeWaypoints: true,
 avoidHighways: false,
 avoidTolls: false
 };
 directionsDisplay.setPanel(document.getElementById('directions-panel'));
 directionsService.route(request,
  function(response,status){
  if (status == google.maps.DirectionsStatus.OK){
  directionsDisplay.setDirections(response);}
  });
}

//infoウィンドウを設定し直す(今は機能していない)
for (var i = 0; i < markerlist2.length; i++) {
  google.maps.event.addListener(markerlist2[i], 'click', function() {
            infowindow[i].open(map9);
        });
}




}
