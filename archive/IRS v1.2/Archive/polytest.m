Ja(1:180,1:180)=5
Jb(1:180,1:180)=10
Jc(1:180,1:180)=15
Jd(1:180,1:180)=20
J = cat(3,[Ja],[Jb],[Jc],[Jd])
[x,y]=size(Ja)

v=[(14384000/900),(14384000/800),(14384000/750),(14384000/670)]

va=repmat(v(1),x,x)
vb=repmat(v(2),x,x)
vc=repmat(v(3),x,x)
vd=repmat(v(4),x,x)

vx=cat(3,(repmat(v([va],[vb],[vc],[vd])

answer=ones(x,x,2);