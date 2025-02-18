"use strict";(self.webpackChunkapp=self.webpackChunkapp||[]).push([[1656],{1656:(F,m,n)=>{n.r(m),n.d(m,{CameraPageModule:()=>h});var u=n(177),C=n(4341),o=n(1075),l=n(8986),i=n(9901),e=n(4438),v=n(5311);const p=[{path:"",component:(()=>{var t;class s{constructor(a,r){this.ngZone=a,this.evaCameraService=r,window.evaWebkitCameraImageResponse=this.evaWebkitCameraImageResponse.bind(this)}ngOnInit(){}captureImage(){this.evaCameraService.captureImage({controlsColor:"#01C1D6",cropToSize:!0,customized:!0,enableViewfinder:!0,flashMode:"off",forceLandscape:!0,previewMode:"Fill",quality:80,titleText:"EVA Template Application",toolbar:{controlsColor:"#01C1D6",backgroundColor:"#7F000000",title:{text:"EVA Template Application",textColor:"#FFFFFF"}},useNativeCamera:!1,viewFinder:{width:300,height:200},viewFinderSize:{width:300,height:200},pictureSize:{width:800,height:600}}).then(r=>{this.ngZone.run(()=>{console.log("CameraPage :: captureImage :: data = ",r),this.serviceResponse=i.j.getString(r)})}).catch(r=>{console.log("CameraPage :: captureImage :: error = ",r),this.serviceResponse=i.j.getString(r)})}captureVideo(){this.evaCameraService.captureVideo().then(a=>{this.ngZone.run(()=>{console.log("CameraPage :: captureVideo :: data = ",a),this.serviceResponse=i.j.getString(a)})}).catch(a=>{console.log("CameraPage :: captureVideo :: error = ",a),this.serviceResponse=i.j.getString(a)})}getCameraDevices(){this.evaCameraService.getCameraDevices().then(a=>{this.ngZone.run(()=>{console.log("CameraPage :: getCameraDevices :: data = ",a),this.serviceResponse=i.j.getString(a)})}).catch(a=>{console.log("CameraPage :: getCameraDevices :: error = ",a),this.serviceResponse=i.j.getString(a)})}registerForUIEvents(){this.evaCameraService.registerForUIEvents().then(a=>{this.ngZone.run(()=>{console.log("CameraPage :: registerForUIEvents :: data = ",a),this.serviceResponse=i.j.getString(a)})}).catch(a=>{console.log("CameraPage :: registerForUIEvents :: error = ",a),this.serviceResponse=i.j.getString(a)})}captureWebkitCameraImage(){var a,r,c;null==(c=null==(r=null==(a=null==window?void 0:window.webkit)?void 0:a.messageHandlers)?void 0:r.eva)||c.postMessage("takePicture")}evaWebkitCameraImageResponse(a){console.log("CameraPage :: evaWebkitCameraImageResponse :: data = ",a),this.serviceResponse=i.j.getString(a)}}return(t=s).\u0275fac=function(a){return new(a||t)(e.rXU(e.SKi),e.rXU(v.BO))},t.\u0275cmp=e.VBU({type:t,selectors:[["app-camera"]],decls:28,vars:1,consts:[["slot","end",1,"ion-no-margin"],[1,"ion-padding-top"],[3,"click"]],template:function(a,r){1&a&&(e.j41(0,"ion-header")(1,"ion-toolbar")(2,"ion-title"),e.EFF(3,"Camera"),e.k0s(),e.j41(4,"ion-buttons",0),e.nrm(5,"ion-menu-button"),e.k0s()()(),e.j41(6,"ion-content")(7,"div",1)(8,"ion-button",2),e.bIt("click",function(){return r.captureImage()}),e.EFF(9,"Capture Image"),e.k0s()(),e.j41(10,"div",1)(11,"ion-button",2),e.bIt("click",function(){return r.captureVideo()}),e.EFF(12,"Capture Video"),e.k0s()(),e.j41(13,"div",1)(14,"ion-button",2),e.bIt("click",function(){return r.getCameraDevices()}),e.EFF(15,"Get Camera Devices"),e.k0s()(),e.j41(16,"div",1)(17,"ion-button",2),e.bIt("click",function(){return r.registerForUIEvents()}),e.EFF(18,"Register For UI Events"),e.k0s()(),e.j41(19,"div",1)(20,"ion-button",2),e.bIt("click",function(){return r.captureWebkitCameraImage()}),e.EFF(21,"Capture Webkit Camera Image"),e.k0s()(),e.j41(22,"div",1)(23,"span"),e.EFF(24,"Service Response:"),e.k0s(),e.EFF(25,"\xa0 "),e.j41(26,"span"),e.EFF(27),e.k0s()()()),2&a&&(e.R7$(27),e.JRh(r.serviceResponse))},dependencies:[o.Jm,o.QW,o.W9,o.eU,o.MC,o.BC,o.ai]}),s})()}];let d=(()=>{var t;class s{}return(t=s).\u0275fac=function(a){return new(a||t)},t.\u0275mod=e.$C({type:t}),t.\u0275inj=e.G2t({imports:[l.iI.forChild(p),l.iI]}),s})(),h=(()=>{var t;class s{}return(t=s).\u0275fac=function(a){return new(a||t)},t.\u0275mod=e.$C({type:t}),t.\u0275inj=e.G2t({imports:[u.MD,C.YN,o.bv,d]}),s})()}}]);