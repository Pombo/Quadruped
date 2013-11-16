use<four_legs.scad>;

X_DEFAULT = 95;
Y_DEFAULT = 95;
Z_DEFAULT = 80;

direction = 0;
distance = 50;

walk(direction, distance);
translate([95+distance/2,95,-Z_DEFAULT]) cube([distance,5,1], true);
translate([-95+distance/2,95,-Z_DEFAULT]) cube([distance,5,1], true);
translate([95+distance/2,-95,-Z_DEFAULT]) cube([distance,5,1], true);
translate([-95+distance/2,-95,-Z_DEFAULT]) cube([distance,5,1], true);



/**
 * Walking routine. Thi is a sinusoidal gait which takes a direction and a distance as inputs. 
 * - If the distance is below the WALK_THRESHOLD only the body moves, no walking.
 * - One leg at a time is up.
 * - The robot's center of mass should be as close as possible to center of the triangle formed by the three other legs.
 * - The lifted leg sequence depends on the orientation:
 *     - <315;45>  -> 1,2,3,4
 *     - <45;135>  -> 2,3,4,1
 *     - <135;225> -> 3,4,1,2
 *     - <225;315> -> 4,1,2,3
 */
module walk(direction, distance) {
    WALK_THRESHOLD = 45;
    GAIT_AMPLITUDE = 50;
    LEG_Z_LIFT = 15;
    STEPS = 4;

    if(distance <= WALK_THRESHOLD) {
        assign (i = distance*cos(direction), 
                j = distance*sin(direction),
                k = 0,
                x1 = X_DEFAULT,y1 = Y_DEFAULT,z1 = Z_DEFAULT,
                x2 = -X_DEFAULT,y2 = Y_DEFAULT,z2 = Z_DEFAULT,
                x3 = -X_DEFAULT,y3 = -Y_DEFAULT,z3 = Z_DEFAULT,
                x4 = X_DEFAULT,y4 = -Y_DEFAULT,z4 = Z_DEFAULT) {
            translate([i,j,k]) cube([15,15,2], true);
            four_legs(x1,y1,z1, x2,y2,z2, x3,y3,z3, x4,y4,z4, i,j,k);
        }
    }
    else {
        assign (i = distance*cos(direction)*$t+cal_x($t, GAIT_AMPLITUDE*sin(360*$t+180), direction), 
                j = distance*sin(direction)*$t+cal_y($t, GAIT_AMPLITUDE*sin(360*$t+180), direction),
                k = 0) {
            translate([i,j,k]) cube([15,15,2], true);
            if(direction >= -45 && direction < 45) {    // 2,1,3,4
	            if($t > 0 && $t <= 1/STEPS) {
	                assign (
	                        x1 = X_DEFAULT,y1 = Y_DEFAULT,z1 = Z_DEFAULT,
	
	                        x2 = -X_DEFAULT+distance*cos(direction)*$t*STEPS,
	                        y2 = Y_DEFAULT+distance*sin(direction)*$t*STEPS,
	                        z2 = Z_DEFAULT-LEG_Z_LIFT*sin(180*$t*STEPS),
	
	                        x3 = -X_DEFAULT,y3 = -Y_DEFAULT,z3 = Z_DEFAULT,
	
	                        x4 = X_DEFAULT,y4 = -Y_DEFAULT,z4 = Z_DEFAULT) {
	                    four_legs(x1,y1,z1, x2,y2,z2, x3,y3,z3, x4,y4,z4, i,j,k);
	                }
	            } else if($t > 1/STEPS && $t <= 2/STEPS) {
	                assign (
	                        x1 = X_DEFAULT+distance*cos(direction)*($t-1/STEPS)*STEPS,
	                        y1 = Y_DEFAULT+distance*sin(direction)*($t-1/STEPS)*STEPS,
	                        z1 = Z_DEFAULT+LEG_Z_LIFT*sin(180*$t*STEPS),
	
	                        x2 = -X_DEFAULT+distance*cos(direction),
	                        y2 = Y_DEFAULT+distance*sin(direction),
	                        z2 = Z_DEFAULT,
	
	                        x3 = -X_DEFAULT,y3 = -Y_DEFAULT,z3 = Z_DEFAULT,
	
	                        x4 = X_DEFAULT,y4 = -Y_DEFAULT,z4 = Z_DEFAULT) {
	                    four_legs(x1,y1,z1, x2,y2,z2, x3,y3,z3, x4,y4,z4, i,j,k);
	                }
	            } else if($t > 2/STEPS && $t <= 3/STEPS) {
	                assign (
	                        x1 = X_DEFAULT+distance*cos(direction),
	                        y1 = Y_DEFAULT+distance*sin(direction),
	                        z1 = Z_DEFAULT,
	
	                        x2 = -X_DEFAULT+distance*cos(direction),
	                        y2 = Y_DEFAULT+distance*sin(direction),
	                        z2 = Z_DEFAULT,
	
	                        x3 = -X_DEFAULT+distance*cos(direction)*($t-2/STEPS)*STEPS,
	                        y3 = -Y_DEFAULT+distance*sin(direction)*($t-2/STEPS)*STEPS,
	                        z3 = Z_DEFAULT-LEG_Z_LIFT*sin(180*$t*STEPS),
	
	                        x4 = X_DEFAULT,y4 = -Y_DEFAULT,z4 = Z_DEFAULT) {
	                    four_legs(x1,y1,z1, x2,y2,z2, x3,y3,z3, x4,y4,z4, i,j,k);
	                }
	            } else if($t > 3/STEPS && $t <= 4/STEPS) {
	                assign (
	                        x1 = X_DEFAULT+distance*cos(direction),
	                        y1 = Y_DEFAULT+distance*sin(direction),
	                        z1 = Z_DEFAULT,
	
	                        x2 = -X_DEFAULT+distance*cos(direction),
	                        y2 = Y_DEFAULT+distance*sin(direction),
	                        z2 = Z_DEFAULT,
	
	                        x3 = -X_DEFAULT+distance*cos(direction),
	                        y3 = -Y_DEFAULT+distance*sin(direction),
	                        z3 = Z_DEFAULT,
	
	                        x4 = X_DEFAULT+distance*cos(direction)*($t-3/STEPS)*STEPS,
	                        y4 = -Y_DEFAULT+distance*sin(direction)*($t-3/STEPS)*STEPS,
	                        z4 = Z_DEFAULT+LEG_Z_LIFT*sin(180*$t*STEPS)) {
	                    four_legs(x1,y1,z1, x2,y2,z2, x3,y3,z3, x4,y4,z4, i,j,k);
	                }
	            }
            } else if(direction >= 45 && direction < 135) {    // 3,2,4,1
	            if($t > 0 && $t <= 1/STEPS) {
	                assign (
	                        x1 = X_DEFAULT,y1 = Y_DEFAULT,z1 = Z_DEFAULT,
	
	                        x2 = -X_DEFAULT,y2 = Y_DEFAULT,z2 = Z_DEFAULT,
	
	                        x3 = -X_DEFAULT+distance*cos(direction)*$t*STEPS,
	                        y3 = -Y_DEFAULT+distance*sin(direction)*$t*STEPS,
	                        z3 = Z_DEFAULT-LEG_Z_LIFT*sin(180*$t*STEPS),
	
	                        x4 = X_DEFAULT,y4 = -Y_DEFAULT,z4 = Z_DEFAULT) {
	                    four_legs(x1,y1,z1, x2,y2,z2, x3,y3,z3, x4,y4,z4, i,j,k);
	                }
	            } else if($t > 1/STEPS && $t <= 2/STEPS) {
	                assign (
	                        x1 = X_DEFAULT,y1 = Y_DEFAULT,z1 = Z_DEFAULT,
	
	                        x2 = -X_DEFAULT+distance*cos(direction)*($t-1/STEPS)*STEPS,
	                        y2 = Y_DEFAULT+distance*sin(direction)*($t-1/STEPS)*STEPS,
	                        z2 = Z_DEFAULT+LEG_Z_LIFT*sin(180*$t*STEPS),
	
	                        x3 = -X_DEFAULT+distance*cos(direction),
	                        y3 = -Y_DEFAULT+distance*sin(direction),
	                        z3 = Z_DEFAULT,
	
	                        x4 = X_DEFAULT,y4 = -Y_DEFAULT,z4 = Z_DEFAULT) {
	                    four_legs(x1,y1,z1, x2,y2,z2, x3,y3,z3, x4,y4,z4, i,j,k);
	                }
	            } else if($t > 2/STEPS && $t <= 3/STEPS) {
	                assign (
	                        x1 = X_DEFAULT,y1 = Y_DEFAULT,z1 = Z_DEFAULT,
	
	                        x2 = -X_DEFAULT+distance*cos(direction),
	                        y2 = Y_DEFAULT+distance*sin(direction),
	                        z2 = Z_DEFAULT,
	
	                        x3 = -X_DEFAULT+distance*cos(direction),
	                        y3 = -Y_DEFAULT+distance*sin(direction),
	                        z3 = Z_DEFAULT,
	
	                        x4 = X_DEFAULT+distance*cos(direction)*($t-2/STEPS)*STEPS,
	                        y4 = -Y_DEFAULT+distance*sin(direction)*($t-2/STEPS)*STEPS,
	                        z4 = Z_DEFAULT-LEG_Z_LIFT*sin(180*$t*STEPS)) {
	                    four_legs(x1,y1,z1, x2,y2,z2, x3,y3,z3, x4,y4,z4, i,j,k);
	                }
	            } else if($t > 3/STEPS && $t <= 4/STEPS) {
	                assign (
	                        x1 = X_DEFAULT+distance*cos(direction)*($t-3/STEPS)*STEPS,
	                        y1 = Y_DEFAULT+distance*sin(direction)*($t-3/STEPS)*STEPS,
	                        z1 = Z_DEFAULT+LEG_Z_LIFT*sin(180*$t*STEPS),
	
	                        x2 = -X_DEFAULT+distance*cos(direction),
	                        y2 = Y_DEFAULT+distance*sin(direction),
	                        z2 = Z_DEFAULT,
	
	                        x3 = -X_DEFAULT+distance*cos(direction),
	                        y3 = -Y_DEFAULT+distance*sin(direction),
	                        z3 = Z_DEFAULT,
	
	                        x4 = X_DEFAULT+distance*cos(direction),
	                        y4 = -Y_DEFAULT+distance*sin(direction),
	                        z4 = Z_DEFAULT) {
	                    four_legs(x1,y1,z1, x2,y2,z2, x3,y3,z3, x4,y4,z4, i,j,k);
	                }
	            }
            } else if(direction >= 135 && direction < 225) {    // 4,3,1,2
                if($t > 0 && $t <= 1/STEPS) {
	                assign (
	                        x1 = X_DEFAULT,y1 = Y_DEFAULT,z1 = Z_DEFAULT,
	
	                        x2 = -X_DEFAULT,y2 = Y_DEFAULT,z2 = Z_DEFAULT,
	
	                        x3 = -X_DEFAULT+distance*cos(direction)*$t*STEPS,
	                        y3 = -Y_DEFAULT+distance*sin(direction)*$t*STEPS,
	                        z3 = Z_DEFAULT-LEG_Z_LIFT*sin(180*$t*STEPS),
	
	                        x4 = X_DEFAULT,y4 = -Y_DEFAULT,z4 = Z_DEFAULT) {
	                    four_legs(x1,y1,z1, x2,y2,z2, x3,y3,z3, x4,y4,z4, i,j,k);
	                }
	            } else if($t > 1/STEPS && $t <= 2/STEPS) {
	                assign (
	                        x1 = X_DEFAULT,y1 = Y_DEFAULT,z1 = Z_DEFAULT,
	
	                        x2 = -X_DEFAULT,y2 = Y_DEFAULT,z2 = Z_DEFAULT,
	
	                        x3 = -X_DEFAULT+distance*cos(direction),
	                        y3 = -Y_DEFAULT+distance*sin(direction),
	                        z3 = Z_DEFAULT,
	
	                        x4 = X_DEFAULT+distance*cos(direction)*($t-1/STEPS)*STEPS,
	                        y4 = -Y_DEFAULT+distance*sin(direction)*($t-1/STEPS)*STEPS,
	                        z4 = Z_DEFAULT+LEG_Z_LIFT*sin(180*$t*STEPS)) {
	                    four_legs(x1,y1,z1, x2,y2,z2, x3,y3,z3, x4,y4,z4, i,j,k);
	                }
	            } else if($t > 2/STEPS && $t <= 3/STEPS) {
	                assign (
	                        x1 = X_DEFAULT+distance*cos(direction)*($t-2/STEPS)*STEPS,
	                        y1 = Y_DEFAULT+distance*sin(direction)*($t-2/STEPS)*STEPS,
	                        z1 = Z_DEFAULT-LEG_Z_LIFT*sin(180*$t*STEPS),
	
	                        x2 = -X_DEFAULT,y2 = 95,z2 = 95,
	
	                        x3 = -X_DEFAULT+distance*cos(direction),
	                        y3 = -Y_DEFAULT+distance*sin(direction),
	                        z3 = Z_DEFAULT,
	
	                        x4 = X_DEFAULT+distance*cos(direction),
	                        y4 = -Y_DEFAULT+distance*sin(direction),
	                        z4 = Z_DEFAULT) {
	                    four_legs(x1,y1,z1, x2,y2,z2, x3,y3,z3, x4,y4,z4, i,j,k);
	                }
	            } else if($t > 3/STEPS && $t <= 4/STEPS) {
	                assign (
	                        x1 = X_DEFAULT+distance*cos(direction),
	                        y1 = Y_DEFAULT+distance*sin(direction),
	                        z1 = Z_DEFAULT,
	
	                        x2 = -X_DEFAULT+distance*cos(direction)*($t-3/STEPS)*STEPS,
	                        y2 = Y_DEFAULT+distance*sin(direction)*($t-3/STEPS)*STEPS,
	                        z2 = Z_DEFAULT+LEG_Z_LIFT*sin(180*$t*STEPS),
	
	                        x3 = -X_DEFAULT+distance*cos(direction),
	                        y3 = -Y_DEFAULT+distance*sin(direction),
	                        z3 = Z_DEFAULT,
	
	                        x4 = X_DEFAULT+distance*cos(direction),
	                        y4 = -Y_DEFAULT+distance*sin(direction),
	                        z4 = Z_DEFAULT) {
	                    four_legs(x1,y1,z1, x2,y2,z2, x3,y3,z3, x4,y4,z4, i,j,k);
	                }
	            }
            } else if(direction >= 225 && direction < 315) {    // 1,4,2,3
                if($t > 0 && $t <= 1/STEPS) {
	                assign (
	                        x1 = X_DEFAULT,y1 = Y_DEFAULT,z1 = Z_DEFAULT,
	
	                        x2 = -X_DEFAULT,y2 = Y_DEFAULT,z2 = Z_DEFAULT,
	
	                        x3 = -X_DEFAULT,y3 = -Y_DEFAULT,z3 = Z_DEFAULT,
	
	                        x4 = X_DEFAULT+distance*cos(direction)*$t*STEPS,
	                        y4 = -Y_DEFAULT+distance*sin(direction)*$t*STEPS,
	                        z4 = Z_DEFAULT-LEG_Z_LIFT*sin(180*$t*STEPS)) {
	                    four_legs(x1,y1,z1, x2,y2,z2, x3,y3,z3, x4,y4,z4, i,j,k);
	                }
	            } else if($t > 1/STEPS && $t <= 2/STEPS) {
	                assign (
	                        x1 = X_DEFAULT+distance*cos(direction)*($t-1/STEPS)*STEPS,
	                        y1 = Y_DEFAULT+distance*sin(direction)*($t-1/STEPS)*STEPS,
	                        z1 = Z_DEFAULT+LEG_Z_LIFT*sin(180*$t*STEPS),
	
	                        x2 = -X_DEFAULT,y2 = Y_DEFAULT,z2 = Z_DEFAULT,
	
	                        x3 = -X_DEFAULT,y3 = -Y_DEFAULT,z3 = Z_DEFAULT,
	
	                        x4 = X_DEFAULT+distance*cos(direction),
	                        y4 = -Y_DEFAULT+distance*sin(direction),
	                        z4 = Z_DEFAULT) {
	                    four_legs(x1,y1,z1, x2,y2,z2, x3,y3,z3, x4,y4,z4, i,j,k);
	                }
	            } else if($t > 2/STEPS && $t <= 3/STEPS) {
	                assign (
	                        x1 = X_DEFAULT+distance*cos(direction),
	                        y1 = Y_DEFAULT+distance*sin(direction),
	                        z1 = Z_DEFAULT,
	
	                        x2 = -X_DEFAULT+distance*cos(direction)*($t-2/STEPS)*STEPS,
	                        y2 = Y_DEFAULT+distance*sin(direction)*($t-2/STEPS)*STEPS,
	                        z2 = Z_DEFAULT-LEG_Z_LIFT*sin(180*$t*STEPS),
	
	                        x3 = -X_DEFAULT,y3 = -Y_DEFAULT,z3 = Z_DEFAULT,
	
	                        x4 = X_DEFAULT+distance*cos(direction),
	                        y4 = -Y_DEFAULT+distance*sin(direction),
	                        z4 = Z_DEFAULT) {
	                    four_legs(x1,y1,z1, x2,y2,z2, x3,y3,z3, x4,y4,z4, i,j,k);
	                }
	            } else if($t > 3/STEPS && $t <= 4/STEPS) {
	                assign (
	                        x1 = X_DEFAULT+distance*cos(direction),
	                        y1 = Y_DEFAULT+distance*sin(direction),
	                        z1 = Z_DEFAULT,
	
	                        x2 = -X_DEFAULT+distance*cos(direction),
	                        y2 = Y_DEFAULT+distance*sin(direction),
	                        z2 = Z_DEFAULT,
	
	                        x3 = -X_DEFAULT+distance*cos(direction)*($t-3/STEPS)*STEPS,
	                        y3 = -Y_DEFAULT+distance*sin(direction)*($t-3/STEPS)*STEPS,
	                        z3 = Z_DEFAULT+LEG_Z_LIFT*sin(180*$t*STEPS),
	
	                        x4 = X_DEFAULT+distance*cos(direction),
	                        y4 = -Y_DEFAULT+distance*sin(direction),
	                        z4 = Z_DEFAULT) {
	                    four_legs(x1,y1,z1, x2,y2,z2, x3,y3,z3, x4,y4,z4, i,j,k);
	                }
	            }
            }
        }
    }
}

// Planar rotation (x' -> x)
function cal_x(x_prime,y_prime,angle) = x_prime*cos(angle) - y_prime*sin(angle);
function cal_y(x_prime,y_prime,angle) = x_prime*sin(angle) + y_prime*cos(angle);