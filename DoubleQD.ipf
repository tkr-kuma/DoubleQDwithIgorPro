#pragma rtGlobals=3		// Use modern global access method and strict wave access.
#include "ImageProcess"
//=====
Macro DoubleQD(U,U12,t,Vg,Delta,name)
variable U=6.1e-3
Prompt U,"U"
variable U12=2.5e-3
Prompt U12,"U12"
variable t=0.6e-3
Prompt t,"tunneling"
Prompt Vg,"Vg"
variable Vg=15e-3
Prompt Delta, "Delta"
variable Delta=1e-4
Prompt name,"GraphName"
string name
variable num=Vg/Delta
Silent 1;PauseUpdate
	

	DoubleQDThread(U,U12,t,Vg,Delta)

	
	Display resultE0dif_0 vs w_V1
	//Please change the below discreption to show color plot
	variable p=1
	Do
	AppendToGraph  $("resultE0dif_"+num2str(p)) vs w_V1
	p+=1
	while(p<(num))
	
	Execute/P "INSERTINCLUDE \"ImageProcess\"";Execute/P "COMPILEPROCEDURES ";Execute/P "COMPILEPROCEDURES "
	CreateImage(name,0,Vg,num,Vg,Delta,num,"Yes")
	ColorPallette("On")
	ModifyGraph width=226.772,height=226.772
	//Please change the upper discreption to show color plot
	
End
//=====
Function DoubleQDFunc(U,U12,t,Vr,Vg,Delta,w)
wave w
variable U,U12,t,Vr,Vg,Delta
variable num=Vg/Delta
variable i,p
Variable A=U/(U+U12)
Variable B=1-A
Silent 1;PauseUpdate

	
Make/N=(num)/D/O w_V1
Make/N=(15,15)/D/O Hamiltonian=0, Hamiltonian1=0, Hamiltonian2=0, Hamiltonian3=0, Hamiltonian4=0

////mu1////
//zero
Hamiltonian1[0][0]=0
//one
Hamiltonian1[1][1]=-1
Hamiltonian1[2][2]=0
//two
Hamiltonian1[3][3]=-2
Hamiltonian1[4][4]=-1
Hamiltonian1[5][5]=0
//three
Hamiltonian1[6][6]=-3
Hamiltonian1[7][7]=-2
Hamiltonian1[8][8]=-1
Hamiltonian1[9][9]=0
//four
Hamiltonian1[10][10]=-4
Hamiltonian1[11][11]=-3
Hamiltonian1[12][12]=-2
Hamiltonian1[13][13]=-1
Hamiltonian1[14][14]=0


////mu2////
//zero
Hamiltonian2[0][0]=0
//one
Hamiltonian2[1][1]=0
Hamiltonian2[2][2]=-1
//two
Hamiltonian2[3][3]=0
Hamiltonian2[4][4]=-1
Hamiltonian2[5][5]=-2
//three
Hamiltonian2[6][6]=0
Hamiltonian2[7][7]=-1
Hamiltonian2[8][8]=-2
Hamiltonian2[9][9]=-3
//four
Hamiltonian2[10][10]=0
Hamiltonian2[11][11]=-1
Hamiltonian2[12][12]=-2
Hamiltonian2[13][13]=-3
Hamiltonian2[14][14]=-4



////Interaction////
//zero
Hamiltonian3[0][0]=0
//one
Hamiltonian3[1][1]=0
Hamiltonian3[2][2]=0
//two
Hamiltonian3[3][3]=U
Hamiltonian3[4][4]=U12
Hamiltonian3[5][5]=U
//three
Hamiltonian3[6][6]=3*U
Hamiltonian3[7][7]=U+2*U12
Hamiltonian3[8][8]=U+2*U12
Hamiltonian3[9][9]=3*U
//four
Hamiltonian3[10][10]=6*U
Hamiltonian3[11][11]=3*U+3*U12
Hamiltonian3[12][12]=2*U+4*U12
Hamiltonian3[13][13]=3*U+3*U12
Hamiltonian3[14][14]=6*U


////tunneling////
//one
Hamiltonian4[1][2]=t
Hamiltonian4[2][1]=t
//two
Hamiltonian4[3][4]=t
Hamiltonian4[4][3]=t
Hamiltonian4[4][5]=t
Hamiltonian4[5][4]=t
//three
Hamiltonian4[6][7]=t
Hamiltonian4[7][6]=t
Hamiltonian4[7][8]=t
Hamiltonian4[8][7]=t
Hamiltonian4[8][9]=t
Hamiltonian4[9][8]=t
//four
Hamiltonian4[10][11]=t
Hamiltonian4[11][10]=t
Hamiltonian4[11][12]=t
Hamiltonian4[12][11]=t
Hamiltonian4[12][13]=t
Hamiltonian4[13][12]=t
Hamiltonian4[13][14]=t
Hamiltonian4[14][13]=t


	i=0
	Do
	w_V1[i]=Delta*i
	
	Hamiltonian=(A*w_V1[i]+B*Vr-U/2)*Hamiltonian1+(B*w_V1[i]+A*Vr-U/2)*Hamiltonian2+Hamiltonian3+Hamiltonian4	

	make/O/N=(15) W_eigenValues
	MatrixEigenV/O/Z Hamiltonian
	make/O/N=(15) W_eigenValues1
	
	variable s
	For (s=0; s<15;s+=1)
	W_eigenValues1[s]=real(W_eigenValues[s])
	endfor
	

	sort W_eigenValues1, W_eigenValues1
	
	w[i]=real(W_eigenValues1[0])
	i+=1	
	While(i<numpnts(w_V1))


End
//-----
Function DoubleQDThread(U,U12,t,Vg,Delta)
variable U,U12,t,Vg,Delta
variable num=Vg/Delta
variable i
	
	For (i=0; i<(num);)
		Make/N=(num)/O $("resultE0_"+num2str(i))
		Make/N=(num)/O $("resultE0dif_"+num2str(i))
		wave w=$("resultE0_"+num2str(i))
		wave dif=$("resultE0dif_"+num2str(i))		
		DoubleQDFunc(U,U12,t,Delta*i,Vg,Delta,w)
		Differentiate w/D=dif
		i+=1
		
		if(i>(num))
		break
		endif
	endfor	

End
//====