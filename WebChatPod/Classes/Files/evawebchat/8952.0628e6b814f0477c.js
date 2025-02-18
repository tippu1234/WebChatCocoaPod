"use strict";(self.webpackChunkapp=self.webpackChunkapp||[]).push([[8952],{8952:(R,l,c)=>{c.r(l),c.d(l,{SpeechPageModule:()=>T});var p=c(177),u=c(4341),a=c(1075),g=c(8986),i=c(9901),e=c(4438),S=c(5311);const v=[{path:"",component:(()=>{var n;class r{constructor(t,o){this.ngZone=t,this.evaSpeechService=o}ngOnInit(){}initialize(){const o={rate:"0.5",language:navigator&&navigator.language?navigator.language:"en-US"};this.evaSpeechService.initialize(null,{apiKey:null,recoMode:"short",version:"1.0",speechRegion:"eastus"},o,null).then(s=>{this.ngZone.run(()=>{console.log("SpeechPage :: initialize :: data = ",s),this.serviceResponse=i.j.getString(s)})}).catch(s=>{console.log("SpeechPage :: initialize :: error = ",s),this.serviceResponse=i.j.getString(s)})}registerForSpeechTrigger(){this.evaSpeechService.registerForSpeechTrigger().then(t=>{this.ngZone.run(()=>{console.log("SpeechPage :: registerForSpeechTrigger :: data = ",t),this.serviceResponse=i.j.getString(t)})}).catch(t=>{console.log("SpeechPage :: registerForSpeechTrigger :: error = ",t),this.serviceResponse=i.j.getString(t)})}startEmbSpeechReco(){this.evaSpeechService.startEmbSpeechReco().then(t=>{this.ngZone.run(()=>{console.log("SpeechPage :: startEmbSpeechReco :: data = ",t),this.serviceResponse=i.j.getString(t)})}).catch(t=>{console.log("SpeechPage :: startEmbSpeechReco :: error = ",t),this.serviceResponse=i.j.getString(t)})}startSpeechReco(){this.evaSpeechService.startSpeechReco().then(t=>{this.ngZone.run(()=>{console.log("SpeechPage :: startSpeechReco :: data = ",t),this.serviceResponse=i.j.getString(t)})}).catch(t=>{console.log("SpeechPage :: startSpeechReco :: error = ",t),this.serviceResponse=i.j.getString(t)})}stopSpeechReco(){this.evaSpeechService.stopSpeechReco().then(t=>{this.ngZone.run(()=>{console.log("SpeechPage :: stopSpeechReco :: data = ",t),this.serviceResponse=i.j.getString(t)})}).catch(t=>{console.log("SpeechPage :: stopSpeechReco :: error = ",t),this.serviceResponse=i.j.getString(t)})}playText(){let t=this.getTextToRead();this.evaSpeechService.playText(t).then(o=>{this.ngZone.run(()=>{console.log("SpeechPage :: playText :: data = ",o),this.serviceResponse=i.j.getString(o)})}).catch(o=>{console.log("SpeechPage :: playText :: error = ",o),this.serviceResponse=i.j.getString(o)})}stopPlayText(){this.evaSpeechService.stopPlayText().then(t=>{this.ngZone.run(()=>{console.log("SpeechPage :: stopPlayText :: data = ",t),this.serviceResponse=i.j.getString(t)})}).catch(t=>{console.log("SpeechPage :: stopPlayText :: error = ",t),this.serviceResponse=i.j.getString(t)})}pauseTTS(){this.evaSpeechService.pauseTTS().then(t=>{this.ngZone.run(()=>{console.log("SpeechPage :: pauseTTS :: data = ",t),this.serviceResponse=i.j.getString(t)})}).catch(t=>{console.log("SpeechPage :: pauseTTS :: error = ",t),this.serviceResponse=i.j.getString(t)})}resumeTTS(){this.evaSpeechService.resumeTTS().then(t=>{this.ngZone.run(()=>{console.log("SpeechPage :: resumeTTS :: data = ",t),this.serviceResponse=i.j.getString(t)})}).catch(t=>{console.log("SpeechPage :: resumeTTS :: error = ",t),this.serviceResponse=i.j.getString(t)})}getTextToRead(){let t="",o=document.getElementsByTagName("p");if(o)for(let s=0;s<o.length;s++)t+=o.item(s).innerText+" \n ";return t}}return(n=r).\u0275fac=function(t){return new(t||n)(e.rXU(e.SKi),e.rXU(S.Yu))},n.\u0275cmp=e.VBU({type:n,selectors:[["app-speech"]],decls:50,vars:1,consts:[["slot","end",1,"ion-no-margin"],[1,"ion-padding-top"],[3,"click"]],template:function(t,o){1&t&&(e.j41(0,"ion-header")(1,"ion-toolbar")(2,"ion-title"),e.EFF(3,"Speech Interaction"),e.k0s(),e.j41(4,"ion-buttons",0),e.nrm(5,"ion-menu-button"),e.k0s()()(),e.j41(6,"ion-content")(7,"p"),e.EFF(8," What\u2019s the Deal with Virtual Reality? "),e.k0s(),e.j41(9,"p"),e.EFF(10," By now, virtual reality (VR) has probably made it on to your radar screen in some way. Maybe you\u2019ve only heard about it in bits and pieces, or maybe you\u2019ve tried it yourself. Whatever the case, virtual reality feels like it could be the new generation of advanced technology. "),e.k0s(),e.j41(11,"p"),e.EFF(12," So, what\u2019s going on with virtual reality? How does it work? What impact is it having on your brain? "),e.k0s(),e.j41(13,"p"),e.EFF(14," Though I have tried a virtual reality headset before, I realized I really didn\u2019t know that much about it, or what is possible with this technology. I\u2019d never really had virtual reality explained to me in a way I was able to understand. "),e.k0s(),e.j41(15,"p"),e.EFF(16," So, I decided to look into it and found a great video from one of our favorite YouTube channels, The Good Stuff, that takes us into the world of virtual reality, exploring its history, psychology, and why it\u2019s so darn fun! "),e.k0s(),e.j41(17,"div",1)(18,"ion-button",2),e.bIt("click",function(){return o.initialize()}),e.EFF(19,"Initialize Speech"),e.k0s()(),e.j41(20,"div",1)(21,"ion-button",2),e.bIt("click",function(){return o.registerForSpeechTrigger()}),e.EFF(22,"Register For Speech Trigger"),e.k0s()(),e.j41(23,"div",1)(24,"ion-button",2),e.bIt("click",function(){return o.startEmbSpeechReco()}),e.EFF(25,"Start Embedded Speech Recognition"),e.k0s()(),e.j41(26,"div",1)(27,"ion-button",2),e.bIt("click",function(){return o.startSpeechReco()}),e.EFF(28,"Start Speech Recognition"),e.k0s()(),e.j41(29,"div",1)(30,"ion-button",2),e.bIt("click",function(){return o.stopSpeechReco()}),e.EFF(31,"Stop Speech Recognition"),e.k0s()(),e.j41(32,"div",1)(33,"ion-button",2),e.bIt("click",function(){return o.playText()}),e.EFF(34,"Play Text"),e.k0s()(),e.j41(35,"div",1)(36,"ion-button",2),e.bIt("click",function(){return o.stopPlayText()}),e.EFF(37,"Stop Play Text"),e.k0s()(),e.j41(38,"div",1)(39,"ion-button",2),e.bIt("click",function(){return o.pauseTTS()}),e.EFF(40,"Pause TTS"),e.k0s()(),e.j41(41,"div",1)(42,"ion-button",2),e.bIt("click",function(){return o.resumeTTS()}),e.EFF(43,"Resume TTS"),e.k0s()(),e.j41(44,"div",1)(45,"span"),e.EFF(46,"Service Response:"),e.k0s(),e.EFF(47,"\xa0 "),e.j41(48,"span"),e.EFF(49),e.k0s()()()),2&t&&(e.R7$(49),e.JRh(o.serviceResponse))},dependencies:[a.Jm,a.QW,a.W9,a.eU,a.MC,a.BC,a.ai]}),r})()}];let d=(()=>{var n;class r{}return(n=r).\u0275fac=function(t){return new(t||n)},n.\u0275mod=e.$C({type:n}),n.\u0275inj=e.G2t({imports:[g.iI.forChild(v),g.iI]}),r})(),T=(()=>{var n;class r{}return(n=r).\u0275fac=function(t){return new(t||n)},n.\u0275mod=e.$C({type:n}),n.\u0275inj=e.G2t({imports:[p.MD,u.YN,a.bv,d]}),r})()}}]);