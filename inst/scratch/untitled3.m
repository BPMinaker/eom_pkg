

global params;

track();
Course=params.course;

%Course(:,5)=0;

for i=2:length(Course)-1
    x1=Course(i-1,1);
    y1=Course(i-1,2);
    x2=Course(i,1);
    y2=Course(i,2);
    x3=Course(i+1,1);
    y3=Course(i+1,2);
    Course(i,4)=1e-5*round(1e5*(2*abs((x2-x1)*(y3-y1)-(x3-x1)*(y2-y1))/sqrt(((x2-x1)^2+(y2-y1)^2)*((x3-x1)^2+(y3-y1)^2)*((x3-x2)^2+(y3-y2)^2))));
%	Course(i,6)=1/Course(i,5);
end
format short
Course
dlmwrite('Course.csv',Course);

