"use strict";(self.webpackChunkapp=self.webpackChunkapp||[]).push([[5586],{5586:(F,r,c)=>{c.r(r),c.d(r,{TouchidPageModule:()=>m});var g=c(177),T=c(4341),s=c(1075),l=c(8986),t=c(9901),e=c(4438),v=c(5311);const p=[{path:"",component:(()=>{var i;class u{constructor(o,n){this.ngZone=o,this.evaTouchidService=n,this.touchIdKey="evaapp",this.initialize()}ngOnInit(){}initialize(){const o="Touch ID for EVA Template Application";this.evaTouchidService.initialize({keyName:this.touchIdKey,readOptions:{description:"Read secret",title:o,fallbackButtonTitle:"Normal Login"},saveOptions:{description:"Save secret",title:o}}).then(h=>{this.ngZone.run(()=>{console.log("TouchidPage :: initialize :: data = ",h),this.serviceResponse=t.j.getString(h)})}).catch(h=>{console.log("TouchidPage :: initialize :: error = ",h),this.serviceResponse=t.j.getString(h)})}saveTouchId(){this.evaTouchidService.saveTouchId(this.touchIdKey).then(o=>{this.ngZone.run(()=>{console.log("TouchidPage :: saveTouchId :: data = ",o),this.serviceResponse=t.j.getString(o)})}).catch(o=>{console.log("TouchidPage :: saveTouchId :: error = ",o),this.serviceResponse=t.j.getString(o)})}readTouchId(){this.evaTouchidService.readTouchId().then(o=>{this.ngZone.run(()=>{console.log("TouchidPage :: readTouchId :: data = ",o),this.serviceResponse=t.j.getString(o)})}).catch(o=>{console.log("TouchidPage :: readTouchId :: error = ",o),this.serviceResponse=t.j.getString(o)})}deleteTouchId(){this.evaTouchidService.deleteTouchId().then(o=>{this.ngZone.run(()=>{console.log("TouchidPage :: deleteTouchId :: data = ",o),this.serviceResponse=t.j.getString(o)})}).catch(o=>{console.log("TouchidPage :: deleteTouchId :: error = ",o),this.serviceResponse=t.j.getString(o)})}getSupportedBiometrics(){this.evaTouchidService.getSupportedBiometrics().then(o=>{this.ngZone.run(()=>{console.log("TouchidPage :: getSupportedBiometrics :: data = ",o),this.serviceResponse=t.j.getString(o)})}).catch(o=>{console.log("TouchidPage :: getSupportedBiometrics :: error = ",o),this.serviceResponse=t.j.getString(o)})}}return(i=u).\u0275fac=function(o){return new(o||i)(e.rXU(e.SKi),e.rXU(v.w$))},i.\u0275cmp=e.VBU({type:i,selectors:[["app-touchid"]],decls:34,vars:2,consts:[["slot","end",1,"ion-no-margin"],[1,"ion-padding-top"],[3,"click"]],template:function(o,n){1&o&&(e.j41(0,"ion-header")(1,"ion-toolbar")(2,"ion-title"),e.EFF(3,"Touch/Face ID"),e.k0s(),e.j41(4,"ion-buttons",0),e.nrm(5,"ion-menu-button"),e.k0s()()(),e.j41(6,"ion-content")(7,"div",1)(8,"span"),e.EFF(9,"Touch Id Key:"),e.k0s(),e.EFF(10,"\xa0"),e.j41(11,"span"),e.EFF(12),e.k0s()(),e.j41(13,"div",1)(14,"ion-button",2),e.bIt("click",function(){return n.initialize()}),e.EFF(15,"Initialize"),e.k0s()(),e.j41(16,"div",1)(17,"ion-button",2),e.bIt("click",function(){return n.saveTouchId()}),e.EFF(18,"Save Touch Id"),e.k0s()(),e.j41(19,"div",1)(20,"ion-button",2),e.bIt("click",function(){return n.readTouchId()}),e.EFF(21,"Read Touch Id"),e.k0s()(),e.j41(22,"div",1)(23,"ion-button",2),e.bIt("click",function(){return n.deleteTouchId()}),e.EFF(24,"Delete Touch Id"),e.k0s()(),e.j41(25,"div",1)(26,"ion-button",2),e.bIt("click",function(){return n.getSupportedBiometrics()}),e.EFF(27,"Get Supported Biometrics"),e.k0s()(),e.j41(28,"div",1)(29,"span"),e.EFF(30,"Service Response:"),e.k0s(),e.EFF(31,"\xa0 "),e.j41(32,"span"),e.EFF(33),e.k0s()()()),2&o&&(e.R7$(12),e.JRh(n.touchIdKey),e.R7$(21),e.JRh(n.serviceResponse))},dependencies:[s.Jm,s.QW,s.W9,s.eU,s.MC,s.BC,s.ai]}),u})()}];let I=(()=>{var i;class u{}return(i=u).\u0275fac=function(o){return new(o||i)},i.\u0275mod=e.$C({type:i}),i.\u0275inj=e.G2t({imports:[l.iI.forChild(p),l.iI]}),u})(),m=(()=>{var i;class u{}return(i=u).\u0275fac=function(o){return new(o||i)},i.\u0275mod=e.$C({type:i}),i.\u0275inj=e.G2t({imports:[g.MD,T.YN,s.bv,I]}),u})()}}]);