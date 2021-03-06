float Stiffness = 5.0;
float BobMass = 0.5;
int StateSize = 3;
float[] InitState = new float[StateSize];
float[] State = new float[StateSize];
float[] StateEul = new float[StateSize];
float[] StateEulC = new float[StateSize];
float[] StateRK4 = new float[StateSize];
int StateCurrentTime = 0;
int StatePositionX = 1;
int StateVelocityX = 2;

int WindowWidthHeight = 300;
float WorldSize = 2.0;
float PixelsPerMeter;
float OriginPixelsX;
float OriginPixelsY;

float ErrEul, ErrEC, ErrRk2, ErrRk4;

int numberOfSteps = 10;
int sizeOfArray;
int counterEnd = 0;

float[] StateGrapCorr;
float[] StateGrapEulC;
float[] StateEulGrap;
float[] StateRk2Grap;
float[] StateRK4Grap;

void setup()
{
    frameRate(60);
    sizeOfArray = numberOfSteps * 60; //FPS
    
    //init of graph arrays
    StateGrapCorr = new float[sizeOfArray];
    StateGrapEulC = new float[sizeOfArray];
    StateEulGrap = new float[sizeOfArray];
    StateRk2Grap = new float[sizeOfArray];
    StateRK4Grap = new float[sizeOfArray];
    
    // Create initial state.
    InitState[StateCurrentTime] = 0.0;
    InitState[StatePositionX] = 0.65;
    InitState[StateVelocityX] = 0.0;

    // Copy initial state to current state.
    // notice that this does not need to know what the meaning of the
    // state elements is, and would work regardless of the state's size.
    for ( int i = 0; i < StateSize; ++i )
    {
        State[i] = InitState[i];
        StateEul[i] = InitState[i];
        StateEulC[i] = InitState[i];
        StateRK4[i] = InitState[i];
    }

    // Set up normalized colors.
    colorMode( RGB, 1.0 );
    
    // Set up the stroke color and width.
    stroke( 0.0 );
    //strokeWeight( 0.01 );
    
    // Create the window size, set up the transformation variables.
    size( 800, 700 );
    PixelsPerMeter = (( float )WindowWidthHeight ) / WorldSize;
    OriginPixelsX = 0.5 * ( float )WindowWidthHeight;
    OriginPixelsY = 0.5 * ( float )WindowWidthHeight;
    
    // A simple println
    println("Real       Euler    Crome       RK2       RK4       ErrEuler       ErrCrome       ErrRK2       ErrRK4");
}

void DrawState()
{
  //EULER
  // Compute end of arm.
    float SpringEndXEuler = PixelsPerMeter * StateEul[StatePositionX];

    fill(1.0, 0.0, 2.0);
    text("Euler", 0.0 , -PixelsPerMeter * 0.58);
    
    // Draw the spring.
    strokeWeight( 1.0 );
    line( 0.0, -PixelsPerMeter * 0.70, SpringEndXEuler, -PixelsPerMeter * 0.70);
    
    // Draw the spring pivot
    fill( 1.0, 0.0, 2.0 );
    ellipse( 0.0, -PixelsPerMeter * 0.70, 
             PixelsPerMeter * 0.03, 
             PixelsPerMeter * 0.03 );
    
    // Draw the spring bob
    fill( 1.0, 0.0, 2.0 );
    ellipse( SpringEndXEuler, -PixelsPerMeter * 0.70, 
             PixelsPerMeter * 0.1, 
             PixelsPerMeter * 0.1 );
             
   
  //EULER-CROME
   // Compute end of arm.
    float SpringEndXEC = PixelsPerMeter * StateEulC[StatePositionX];
    
    fill(1.0, 234.0, 0 );
    text("Euler Crome", 0.0 , -PixelsPerMeter * 0.35);
  
    // Draw the spring.
    strokeWeight( 1.0 );
    line( 0.0, -PixelsPerMeter * 0.50, SpringEndXEC, -PixelsPerMeter * 0.50 );

    // Draw the spring pivot
    fill( 1.0, 234.0, 0.0 );
    ellipse( 0.0, -PixelsPerMeter * 0.50, 
             PixelsPerMeter * 0.03, 
             PixelsPerMeter * 0.03 );
    
    // Draw the spring bob
    fill( 1.0, 234.0, 0.0 );
    ellipse( SpringEndXEC, -PixelsPerMeter * 0.50, 
             PixelsPerMeter * 0.1, 
             PixelsPerMeter * 0.1 );
            
  //RK2
    // Compute end of arm.
    float SpringEndX = PixelsPerMeter * State[StatePositionX];

    // Compute the CORRECT position.
    float sqrtKoverM = sqrt( Stiffness / BobMass );
    float x0 = InitState[StatePositionX];
    float v0 = InitState[StateVelocityX];
    float t = State[StateCurrentTime];
    float CorrectPositionX = ( x0 * cos( sqrtKoverM * t ) ) +
        ( ( v0 / sqrtKoverM ) * sin( sqrtKoverM + t ) );
    
    // Compute draw pos for "correct"
    float CorrectEndX = PixelsPerMeter * CorrectPositionX;

  fill(1.0, 0.0, 0 );
  text("RK2", 0.0 , PixelsPerMeter * 0.12);

    // Draw the spring.
    strokeWeight( 1.0 );
    line( 0.0, 0.0, SpringEndX, 0.0 );
          
    // Draw the spring pivot
    fill( 1.0, 0.0, 0.0 );
    ellipse( 0.0, 0.0, 
             PixelsPerMeter * 0.03, 
            PixelsPerMeter * 0.03 );
      
    // Draw the spring bob
    fill( 1.0, 0.0, 0.0 );
    ellipse( SpringEndX, 0.0, 
             PixelsPerMeter * 0.1, 
             PixelsPerMeter * 0.1 );


//CORRECTA
  fill(0.0, 0.0, 1.0 );
  text("Real solution", 0.0 ,-PixelsPerMeter * 0.10);
  
    // Draw the spring.
    strokeWeight( 1.0 );
    line(0 ,  -PixelsPerMeter * 0.25, CorrectEndX,  -PixelsPerMeter * 0.25 );

    // Draw the spring pivot
    fill( 0.0, 0.0, 1.0 );
    ellipse( 0.0, -PixelsPerMeter * 0.25, 
             PixelsPerMeter * 0.03, 
            PixelsPerMeter * 0.03 );
      
    // Draw the correct bob in blue
    fill( 0.0, 0.0, 1.0 );
    ellipse( CorrectEndX, -PixelsPerMeter * 0.25,
            PixelsPerMeter * 0.1,
            PixelsPerMeter * 0.1 );

//RK4
 float SpringEndXRK4 = PixelsPerMeter * StateRK4[StatePositionX];

  fill(1.0, 1.0, 1.0 );
  text("RK4", 0.0 , PixelsPerMeter * 0.35);

    // Draw the spring.
    strokeWeight( 1.0 );
    line( 0.0, PixelsPerMeter * 0.20, SpringEndXRK4, PixelsPerMeter * 0.20);
          
    // Draw the spring pivot
    fill( 1.0, 1.0, 1.0 );
    ellipse( 0.0,PixelsPerMeter * 0.20, 
             PixelsPerMeter * 0.03, 
            PixelsPerMeter * 0.03 );
      
    // Draw the spring bob
    fill( 1.0, 1.0, 1.0 );
    ellipse( SpringEndXRK4,PixelsPerMeter * 0.20, 
             PixelsPerMeter * 0.1, 
             PixelsPerMeter * 0.1 );



 //impresion de los errores y soluciones
 ErrEul = SpringEndXEuler - CorrectEndX;
 ErrEC = SpringEndXEC - CorrectEndX;
 ErrRk2 = SpringEndX - CorrectEndX;
 ErrRk4 = SpringEndXRK4 - CorrectEndX;
 
 
 fill( 0.0, 0.0, 1.0 );
 text("Real solution: ", -150 , 86);
 text(CorrectEndX, -73, 86);
 
 fill( 1.0, 1.0, 1.0 );
 text("RK4: ", -150 , 100);
 text(SpringEndXRK4, -120, 100);
 text("Error RK4: ", -8 , 100);
 text(ErrRk4, 55 , 100);
 
 fill(1.0, 0.0, 0 );
 text("RK2: ", -150 , 115);
 text(SpringEndX, -120 , 115);
 text("Error RK2: " , -8 , 115);
 text(ErrRk2, 55 , 115);

 fill(1.0, 1.0, 0 );
 text("Euler Crome: ", -150, 128);
 text(SpringEndXEC, -75, 128);
 text("Error Euler C: ", -8 , 128);
 text(ErrEC, 70 , 128);

 fill(1.0, 0.0, 1.0);
 text("Euler: ", -150, 142);
 text(SpringEndXEuler, -115, 142);
 text("Error Euler: ", -8 , 142);
 text(ErrEul, 58 , 142);
 
 print(CorrectEndX + "   " + SpringEndXEuler  + "   " + SpringEndXEC + "   " + SpringEndX  + "   " + SpringEndXRK4 + "   " + ErrEul + "   " + ErrEC + "   " + ErrRk2 + "   " + ErrRk4 );
 println();


 StateGrapCorr[counterEnd] = CorrectEndX;
 StateEulGrap[counterEnd] = SpringEndXEuler;
 StateGrapEulC[counterEnd] = SpringEndXEC;
 StateRk2Grap[counterEnd] = SpringEndX;
 StateRK4Grap[counterEnd]= SpringEndXRK4;
 
 for(int f = 0; f < counterEnd; f++){
   
    // Draw Euler
    stroke( 0.0, 0.0, 1.0 );
    fill( 0.0, 0.0, 1.0 );
    ellipse( (StateGrapCorr[f] * 0.60) + 180, (f * 0.60) - 140, 1, 1);
    
    stroke( 1.0, 0.0, 1.0 );
    fill( 1.0, 0.0, 1.0 );
    ellipse( (StateEulGrap[f] * 0.60) + 180, (f * 0.60) - 140, 1, 1);
    // End Draw Euler
    
    // Draw EulC
    stroke( 0.0, 0.0, 1.0 );
    fill( 0.0, 0.0, 1.0 );
    ellipse( (StateGrapCorr[f] * 0.60) + 380, (f * 0.60) - 140, 1, 1);
    
    
    stroke( 1.0, 1.0, 0  );
    fill( 1.0, 1.0, 0.0 );
    ellipse( (StateGrapEulC[f] * 0.60) + 380,(f * 0.60) - 140, 1, 1);
    //End Draw EulC
    
    // Draw Rk2
    stroke( 0.0, 0.0, 1.0 );
    fill( 0.0, 0.0, 1.0 );
    ellipse( (StateGrapCorr[f] * 0.60) - 80, (f * 0.60) + 180, 1, 1);
    
    stroke( 1.0, 0.0, 0 );
    fill( 1.0, 0.0, 0.0 );
    ellipse( (StateRk2Grap[f] * 0.60) - 80, (f * 0.60) + 180, 1, 1);
    // End Rk2
    
    // Draw Rk4
    stroke( 0.0, 0.0, 1.0 );
    fill( 0.0, 0.0, 1.0 );
    ellipse( (StateGrapCorr[f] * 0.60) + 530, (f * 0.60) + 180, 1, 1);
   
   
   stroke( 1.0, 1.0, 1.0 );
   fill( 1.0, 1.0, 1.0 );
   ellipse( (StateRK4Grap[f] * 0.60) + 530, (f * 0.60) + 180, 1, 1);
    // End Rk4
    
    stroke( 0, 0, 0 );
    
/*            fill( 1.0, 1.0, 1.0 );
    ellipse(  StateEulGrap[f]* 0.60, f * 0.60, 
             PixelsPerMeter * 0.03, 
            PixelsPerMeter * 0.03 );
            
            fill( 0.0, 0.0, 1.0 );
    ellipse(  StateGrapEulC[f]* 0.60, f * 0.60, 
             PixelsPerMeter * 0.03, 
            PixelsPerMeter * 0.03);
            
            fill( 0.0, 1.0, 1.0 );
    ellipse(  StateRk2Grap[f] * 0.60, f * 0.60, 
             PixelsPerMeter * 0.03, 
            PixelsPerMeter * 0.03 );
            
            fill( 1.0, 0.0, 0.0 );
    ellipse(  StateRK4Grap[f] * 0.60, f * 0.60, 
             PixelsPerMeter * 0.03, 
            PixelsPerMeter * 0.03);*/
 }
 
}

// Acceleration from Position.
float A_from_X( float i_x )
{
    return -( Stiffness / BobMass ) * i_x;
}

// Time Step function.
void TimeStepRK2( float i_dt )
{
//EulerChrome
  // Compute acceleration from current position.
    float AEC = ( -Stiffness / BobMass ) * StateEulC[StatePositionX];

    // Update velocity based on acceleration.
    StateEulC[StateVelocityX] += i_dt * AEC;

    // Update position based on current velocity.
    StateEulC[StatePositionX] += i_dt * StateEulC[StateVelocityX];

    // Update current time.
    StateEulC[StateCurrentTime] += i_dt;
    
    
//Euler
   // Compute acceleration from current position.
    float A = ( -Stiffness / BobMass ) * StateEul[StatePositionX];

    // Update position based on current velocity.
    StateEul[StatePositionX] += i_dt * StateEul[StateVelocityX];

    // Update velocity based on acceleration.
    StateEul[StateVelocityX] += i_dt * A;

    // Update current time.
    StateEul[StateCurrentTime] += i_dt;
  
  
//RK2
    float vStar1 = State[StateVelocityX];
    float aStar1 = A_from_X( State[StatePositionX] );

    float vStar2 = State[StateVelocityX] + ( i_dt * aStar1 );
    float xTmp = State[StatePositionX] + ( i_dt * vStar1 );
    float aStar2 = A_from_X( xTmp );

    State[StatePositionX] += ( i_dt / 2.0 ) * ( vStar1 + vStar2 );
    State[StateVelocityX] += ( i_dt / 2.0 ) * ( aStar1 + aStar2 );

    // Update current time.
    State[StateCurrentTime] += i_dt;
    
      
//RK4
    float vStar1RK4 = StateRK4[StateVelocityX];
    float aStar1RK4 = A_from_X( State[StatePositionX] );

    float vStar2RK4 = StateRK4[StateVelocityX] + ( ( i_dt / 2.0 ) * aStar1RK4 );
    float xTmp2RK4 = StateRK4[StatePositionX] + ( ( i_dt / 2.0 ) * vStar1RK4 );
    float aStar2RK4 = A_from_X( xTmp2RK4 );

    float vStar3RK4 = StateRK4[StateVelocityX] + ( ( i_dt / 2.0 ) * aStar2RK4 );
    float xTmp3RK4 = StateRK4[StatePositionX] + ( ( i_dt / 2.0 ) * vStar2RK4 );
    float aStar3RK4 = A_from_X( xTmp3RK4 );

    float vStar4RK4 = State[StateVelocityX] + ( i_dt * aStar3RK4 );
    float xTmp4RK4 = State[StatePositionX] + ( i_dt * vStar3RK4 );
    float aStar4RK4 = A_from_X( xTmp4RK4 );

    StateRK4[StatePositionX] += ( i_dt / 6.0 ) * 
        ( vStar1RK4 + (2.0*vStar2RK4) + (2.0*vStar3RK4) + vStar4RK4 );
    StateRK4[StateVelocityX] += ( i_dt / 6.0 ) * 
        ( aStar1RK4 + (2.0*aStar2RK4) + (2.0*aStar3RK4) + aStar4RK4 );

    // Update current time.
    StateRK4[StateCurrentTime] += i_dt;
}

// Reset function. If the key 'r' is released in the display, 
// copy the initial state to the state.
void keyReleased()
{
    if ( key == 114 )
    {
        for ( int i = 0; i < StateSize; ++i )
        {
            State[i] = InitState[i];
            StateEul[i] = InitState[i];
            StateEulC[i] = InitState[i];
            StateRK4[i] = InitState[i];
        }
    }  
}

void draw()
{       
 if (counterEnd < sizeOfArray){
   
    // Time Step.
    TimeStepRK2( 5.0/150.0 );

    // Clear the display to a constant color.
    background( 0.75 );

    // Translate to the origin.
    translate( OriginPixelsX, OriginPixelsY );

    // Draw the simulation
    DrawState();
    
    // Add one to the counter
    counterEnd++;
    println(counterEnd);

  }else{
    exit();
  }
}