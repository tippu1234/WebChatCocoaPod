"use strict";(self.webpackChunkapp=self.webpackChunkapp||[]).push([[9488],{7107:(m,g,a)=>{a.r(g),a.d(g,{ContactPageModule:()=>P});var C=a(177),u=a(4341),c=a(1075),l=a(8986),r=a(9901),t=a(4438),v=a(5311);const p=[{path:"",component:(()=>{var n;class s{constructor(o,e){this.ngZone=o,this.evaContactService=e}ngOnInit(){}getContacts(){this.evaContactService.getContacts({}).then(e=>{this.ngZone.run(()=>{console.log("ContactPage :: getContacts :: data = ",e),this.serviceResponse=r.j.getString(e)})}).catch(e=>{console.log("ContactPage :: getContacts :: error = ",e),this.serviceResponse=r.j.getString(e)})}pickContact(){this.evaContactService.pickContact().then(o=>{this.ngZone.run(()=>{console.log("ContactPage :: pickContact :: data = ",o),this.serviceResponse=r.j.getString(o)})}).catch(o=>{console.log("ContactPage :: pickContact :: error = ",o),this.serviceResponse=r.j.getString(o)})}}return(n=s).\u0275fac=function(o){return new(o||n)(t.rXU(t.SKi),t.rXU(v.CF))},n.\u0275cmp=t.VBU({type:n,selectors:[["app-contact"]],decls:19,vars:1,consts:[["slot","end",1,"ion-no-margin"],[1,"ion-padding-top"],[3,"click"]],template:function(o,e){1&o&&(t.j41(0,"ion-header")(1,"ion-toolbar")(2,"ion-title"),t.EFF(3,"Contact"),t.k0s(),t.j41(4,"ion-buttons",0),t.nrm(5,"ion-menu-button"),t.k0s()()(),t.j41(6,"ion-content")(7,"div",1)(8,"ion-button",2),t.bIt("click",function(){return e.getContacts()}),t.EFF(9,"Get Contacts"),t.k0s()(),t.j41(10,"div",1)(11,"ion-button",2),t.bIt("click",function(){return e.pickContact()}),t.EFF(12,"Pick Contact"),t.k0s()(),t.j41(13,"div",1)(14,"span"),t.EFF(15,"Service Response:"),t.k0s(),t.EFF(16,"\xa0 "),t.j41(17,"span"),t.EFF(18),t.k0s()()()),2&o&&(t.R7$(18),t.JRh(e.serviceResponse))},dependencies:[c.Jm,c.QW,c.W9,c.eU,c.MC,c.BC,c.ai]}),s})()}];let d=(()=>{var n;class s{}return(n=s).\u0275fac=function(o){return new(o||n)},n.\u0275mod=t.$C({type:n}),n.\u0275inj=t.G2t({imports:[l.iI.forChild(p),l.iI]}),s})(),P=(()=>{var n;class s{}return(n=s).\u0275fac=function(o){return new(o||n)},n.\u0275mod=t.$C({type:n}),n.\u0275inj=t.G2t({imports:[C.MD,u.YN,c.bv,d]}),s})()}}]);