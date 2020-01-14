%Zuerst: berechne die lexikographischen Minima:

A =[-1,0,0,0,3,0;
    1,0,0,0,-6,0;
    0,-1,0,0,3,0;
    0,1,0,0,-6,0;
    0,0,-1,0,0,4;
    0,0,1,0,0,-4.5;
    0,0,0,-1,0,4;
    0,0,0,1,0,-4.5;
    0,0,0,0,1,1];

b =[0;0;0;0;0;0;0;0;5];

C = [-15,-30,15,25,0,0;
    15,4,1,2,0,0];

lb = zeros(6,1);
ub = 10*ones(6,1);

Aeq = [];
beq = [];

%definiere jene Indizes der ganzzahligen Variablen:
ganzzahlig_index = [5,6];


%lexmin(f1): x-Wert, wo das Minimum von f1 angenommen wird:
lexmin1 = intlinprog(C(1,:),ganzzahlig_index,A,b,Aeq,beq ,lb, ub);
%lexmin(f2): x-Wert, wo das Minimum von f2 angenommen wird:
lexmin2 = intlinprog(C(2,:),ganzzahlig_index,A,b, Aeq,beq ,lb,ub);


%Koordinate1: y-Wert von lexmin1:
Koordinate1 = C*lexmin1;
%Koordinate2: y-Wert von lexmin2:
Koordinate2 = C*lexmin2;

%Berechne Idealpunkt:
ideal=zeros(1,2);
ideal(1)= Koordinate1(1);
ideal(2)=Koordinate2(2);
%der Idealpunkt ist(-450,0)


%Idee: Wir legen eine Hyperebene durch die beiden lexmin und verschieben
%die Hyperebene dann parallel auf den Idealpunkt, wir starten mit folgender
%Gerade: g(alpha)= (-450,190)+alpha(450,-190) und verschieben sie, sodass
%sie durch den Idealpunkt verläuft: g(alpha)=(-450,0)+alpha(450,-190).


%Wähle r=(0,1), weil der Stützvektor der neuen Hyerebene dem
%Idealpunkt entspricht und senkrecht unter dem 1.lexikographischen Minimum
%liegt.

%PS(a,r)

%Zielfunktion "beinhaltet" auch die anderen Variablen, vorallem aber unser
%t
t=[0,0,0,0,0,0,1];

%Blockmatrix:
%(a+tr) - f(x) ≧ 0
% ⇔  -(a+tr) + f(x) ≦ 0
% ⇔ -tr + f(x) ≦ a
% ⇔ -tr + Cx ≦ a
% ⇔ [C -r]*⌈x⌉ ≦ a
%          ⌊t⌋ 
% ⇒ zusammen mit den Matrizen für Ax≦b folgt dann:
% ⇒ [C -r]*⌈x⌉ ≦ ⌈a⌉
%   ⌊A  0⌋ ⌊t⌋   ⌊b⌋

%A_neu: [C -r]
%       ⌊A  0⌋
A_neu = [-15,-30,15,25,0,0,0;
         15,4,1,2,0,0,-1;            
         -1,0,0,0,3,0,0;
          1,0,0,0,-6,0,0;
          0,-1,0,0,3,0,0;
          0,1,0,0,-6,0,0;
          0,0,-1,0,0,4,0;
          0,0,1,0,0,-4.5,0;
          0,0,0,-1,0,4,0;
          0,0,0,1,0,-4.5,0;
          0,0,0,0,1,1,0];
      
% b_neu: ⌈a⌉
%        ⌊b⌋
%in b_neu ist der erste Referenzpunkt, nämlich der Idealpunkt (-450,0),
%eingebaut:
b_neu=[-450;0;0;0;0;0;0;0;0;0;5];

%t ist nach oben und unten unbeschränkt, da t∊ℝ
%währrend 0 ≦ x ≦ 10 gilt:
lb_neu=[0,0,0,0,0,0,-inf];
ub_neu=[10,10,10,10,10,10,inf];

%als Schrittweite wird 0.1 gewählt; deshalb hat x_effizient 100 Spalten:
x_effizient=zeros(7,100); 
%x_effizient: speicher Lösungsvektor vom ersten Referenzpunkt a=Idealpunkt:
x_effizient(:,1) = intlinprog(t,ganzzahlig_index,A_neu,b_neu,[],[],lb_neu,ub_neu);

%alpha: Länge der Richtung der Hypergerade:
alpha = 0;

zaehler=2;
while alpha <= 1
    
    alpha = alpha+0.01;
    
    %bewege auf der Geraden eine Schrittweite alpha weiter:
    hilfe(1)=-450+alpha*450;
    hilfe(2)=-190*alpha;
    
    %speichere diesen Punkt als neuen Referenzpunkt im Vektor b:
    b_neu(1) = hilfe(1);
    b_neu(2) = hilfe(2);
    
    %speichere ab der 2. Spalte den zugehörigen Lösungsvektor:
    x_effizient(:,zaehler)=intlinprog(t,[5,6],A_neu,b_neu,[],[],lb_neu,ub_neu);
    zaehler = zaehler+1;
end

%Rechne aus den Lösungsvektor (x-Wert) den zugehörigen Funktionsvektor
%(y-Wert aus):
%Erweitere C um einen 0 Eintrag, damit der Zielfunktionswert t im
%Lösungsvektor nicht berücksichtigt wird:
C_mit_t=[-15,-30,15,25,0,0,0;
    15,4,1,2,0,0,0];

y_effizient = zeros(2,100);
y_effizient = C_mit_t*x_effizient;


%Plote Lösungen von PS(a,r):

figure(1)
hold on
axis([-450 20 -200 200])
for i = 1:101
    %Plote die Einträge in der Matrix als Punkte
    plot(y_effizient(1,i),y_effizient(2,i),'.r')
end


         
