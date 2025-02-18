"use strict";(self.webpackChunkapp=self.webpackChunkapp||[]).push([[8420],{8420:(j,m,l)=>{l.r(m),l.d(m,{LaunchappPageModule:()=>k});var L=l(177),g=l(4341),c=l(1075),d=l(8986),s=l(9901),e=l(4438),_=l(5311);const P=[{path:"",component:(()=>{var i;class p{constructor(n,t){this.ngZone=n,this.evaLaunchappService=t,this.link="https://www.google.co.in",this.emailSubject="<b>Test Email Subject</a>",this.emailBody="Test Email Body",this.contactName="Test User",this.contactPhoneNumber="0123456789",this.printInfoJson={},this.shareJson={}}ngOnInit(){}openLink(){this.evaLaunchappService.openLink(this.link).then(n=>{this.ngZone.run(()=>{console.log("LaunchappPage :: openLink :: data = ",n),this.serviceResponse=s.j.getString(n)})}).catch(n=>{console.log("LaunchappPage :: openLink :: error = ",n),this.serviceResponse=s.j.getString(n)})}sendEmail(){this.evaLaunchappService.sendEmail({to:[],cc:[],bcc:[],subject:this.emailSubject,body:this.emailBody,attachments:[{fileName:this.emailAttachmentFileName,contentType:this.emailAttachmentContentType,emailAs:this.emailAttachmentFileName,data:this.emailAttachmentBase64Data}],html:!0}).then(t=>{this.ngZone.run(()=>{console.log("LaunchappPage :: sendEmail :: data = ",t),this.serviceResponse=s.j.getString(t)})}).catch(t=>{console.log("LaunchappPage :: sendEmail :: error = ",t),this.serviceResponse=s.j.getString(t)})}addContact(){this.evaLaunchappService.addContact({name:this.contactName,phone:this.contactPhoneNumber,email:"",company:"",notes:"",secondary_phone:"",secondary_email:"",job_title:"",data:""}).then(t=>{this.ngZone.run(()=>{console.log("LaunchappPage :: addContact :: data = ",t),this.serviceResponse=s.j.getString(t)})}).catch(t=>{console.log("LaunchappPage :: addContact :: error = ",t),this.serviceResponse=s.j.getString(t)})}showAppSettings(){this.evaLaunchappService.showAppSettings().then(n=>{this.ngZone.run(()=>{console.log("LaunchappPage :: showAppSettings :: data = ",n),this.serviceResponse=s.j.getString(n)})}).catch(n=>{console.log("LaunchappPage :: showAppSettings :: error = ",n),this.serviceResponse=s.j.getString(n)})}print(){this.evaLaunchappService.print(this.printInfoJson).then(n=>{this.ngZone.run(()=>{console.log("LaunchappPage :: print :: data = ",n),this.serviceResponse=s.j.getString(n)})}).catch(n=>{console.log("LaunchappPage :: print :: error = ",n),this.serviceResponse=s.j.getString(n)})}share(){this.evaLaunchappService.share(this.shareJson).then(n=>{this.ngZone.run(()=>{console.log("LaunchappPage :: share :: data = ",n),this.serviceResponse=s.j.getString(n)})}).catch(n=>{console.log("LaunchappPage :: share :: error = ",n),this.serviceResponse=s.j.getString(n)})}openBrowser(){this.evaLaunchappService.openBrowser(this.link).then(n=>{this.ngZone.run(()=>{console.log("LaunchappPage :: openBrowser :: data = ",n),this.serviceResponse=s.j.getString(n)})}).catch(n=>{console.log("LaunchappPage :: openBrowser :: error = ",n),this.serviceResponse=s.j.getString(n)})}closeBrowser(){this.evaLaunchappService.closeBrowser().then(n=>{this.ngZone.run(()=>{console.log("LaunchappPage :: closeBrowser :: data = ",n),this.serviceResponse=s.j.getString(n)})}).catch(n=>{console.log("LaunchappPage :: closeBrowser :: error = ",n),this.serviceResponse=s.j.getString(n)})}readFileToPrint(n){let o=n.currentTarget.files;if(o){let a=o[0],r=new FileReader,u=this;r.readAsDataURL(a),r.onloadend=function(v){u.printInfoJson={fileName:a.name,contentType:a.type,data:r.result,scale:0,monochrome:!1,portrait:!1}}}}readEmailAttachmentFile(n){let o=n.currentTarget.files;if(o){let a=o[0],r=new FileReader,u=this;r.readAsDataURL(a),r.onloadend=function(v){u.emailAttachmentFileName=a.name,u.emailAttachmentContentType=a.type,u.emailAttachmentBase64Data=r.result}}}}return(i=p).\u0275fac=function(n){return new(n||i)(e.rXU(e.SKi),e.rXU(_.w3))},i.\u0275cmp=e.VBU({type:i,selectors:[["app-launchapp"]],decls:45,vars:7,consts:[["slot","end",1,"ion-no-margin"],[1,"ion-padding-top"],["placeholder","Link to open in browser",3,"ngModelChange","ngModel"],[3,"click"],["placeholder","Email subject",3,"ngModelChange","ngModel"],["placeholder","Email Body",3,"ngModelChange","ngModel"],["type","file",3,"change"],["placeholder","Contact name",3,"ngModelChange","ngModel"],["placeholder","Contact phone number",3,"ngModelChange","ngModel"]],template:function(n,t){1&n&&(e.j41(0,"ion-header")(1,"ion-toolbar")(2,"ion-title"),e.EFF(3,"LaunchApp"),e.k0s(),e.j41(4,"ion-buttons",0),e.nrm(5,"ion-menu-button"),e.k0s()()(),e.j41(6,"ion-content")(7,"div",1)(8,"ion-input",2),e.mxI("ngModelChange",function(a){return e.DH7(t.link,a)||(t.link=a),a}),e.k0s(),e.j41(9,"ion-button",3),e.bIt("click",function(){return t.openLink()}),e.EFF(10,"Open Link in Browser"),e.k0s()(),e.j41(11,"div",1)(12,"ion-input",4),e.mxI("ngModelChange",function(a){return e.DH7(t.emailSubject,a)||(t.emailSubject=a),a}),e.k0s(),e.j41(13,"ion-input",5),e.mxI("ngModelChange",function(a){return e.DH7(t.emailBody,a)||(t.emailBody=a),a}),e.k0s(),e.j41(14,"input",6),e.bIt("change",function(a){return t.readEmailAttachmentFile(a)}),e.k0s(),e.j41(15,"ion-button",3),e.bIt("click",function(){return t.sendEmail()}),e.EFF(16,"Send Email"),e.k0s()(),e.j41(17,"div",1)(18,"ion-input",7),e.mxI("ngModelChange",function(a){return e.DH7(t.contactName,a)||(t.contactName=a),a}),e.k0s(),e.j41(19,"ion-input",8),e.mxI("ngModelChange",function(a){return e.DH7(t.contactPhoneNumber,a)||(t.contactPhoneNumber=a),a}),e.k0s(),e.j41(20,"ion-button",3),e.bIt("click",function(){return t.addContact()}),e.EFF(21,"Add Contact"),e.k0s()(),e.j41(22,"div",1)(23,"ion-button",3),e.bIt("click",function(){return t.showAppSettings()}),e.EFF(24,"Show App Settings"),e.k0s()(),e.j41(25,"div",1)(26,"input",6),e.bIt("change",function(a){return t.readFileToPrint(a)}),e.k0s(),e.j41(27,"ion-button",3),e.bIt("click",function(){return t.print()}),e.EFF(28,"Print"),e.k0s()(),e.j41(29,"div",1)(30,"ion-button",3),e.bIt("click",function(){return t.share()}),e.EFF(31,"Share"),e.k0s()(),e.j41(32,"div",1)(33,"ion-input",2),e.mxI("ngModelChange",function(a){return e.DH7(t.link,a)||(t.link=a),a}),e.k0s(),e.j41(34,"ion-button",3),e.bIt("click",function(){return t.openBrowser()}),e.EFF(35,"Open Browser"),e.k0s()(),e.j41(36,"div",1)(37,"ion-button",3),e.bIt("click",function(){return t.closeBrowser()}),e.EFF(38,"Close Browser"),e.k0s()(),e.j41(39,"div",1)(40,"span"),e.EFF(41,"Service Response:"),e.k0s(),e.EFF(42,"\xa0 "),e.j41(43,"span"),e.EFF(44),e.k0s()()()),2&n&&(e.R7$(8),e.R50("ngModel",t.link),e.R7$(4),e.R50("ngModel",t.emailSubject),e.R7$(),e.R50("ngModel",t.emailBody),e.R7$(5),e.R50("ngModel",t.contactName),e.R7$(),e.R50("ngModel",t.contactPhoneNumber),e.R7$(14),e.R50("ngModel",t.link),e.R7$(11),e.JRh(t.serviceResponse))},dependencies:[g.BC,g.vS,c.Jm,c.QW,c.W9,c.eU,c.$w,c.MC,c.BC,c.ai,c.Gw]}),p})()}];let f=(()=>{var i;class p{}return(i=p).\u0275fac=function(n){return new(n||i)},i.\u0275mod=e.$C({type:i}),i.\u0275inj=e.G2t({imports:[d.iI.forChild(P),d.iI]}),p})(),k=(()=>{var i;class p{}return(i=p).\u0275fac=function(n){return new(n||i)},i.\u0275mod=e.$C({type:i}),i.\u0275inj=e.G2t({imports:[L.MD,g.YN,c.bv,f]}),p})()}}]);