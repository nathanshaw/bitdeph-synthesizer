//  ViewController.m
//  BiTDEPH Synthesizer
//
//  Created by Nathan Villicaña-Shaw on 2/11/16.
//  Copyright © 2016 Nathan Villicaña-Shaw. All rights reserved.

#import "ViewController.h"
#import "ShaderHelper.h"
#import "Texture.h"

#import "AudioManager.h"
#import "Random.h"

#import <vector>
#import <list>
#import <map>
#include <tuple>

#define WAVEFORM_GEO_SIZE 2048

// global variables for now
// TODO: put into some sort of object state
GLuint _shaderProgram;
GLuint _mvpUniform;
GLuint _normalMatrixUniform;

GLuint _texShaderProgram;
GLuint _texMvpUniform;
GLuint _texNormalMatrixUniform;
GLuint _texTexUniform;

GLKMatrix4 projection;
GLKMatrix4 modelView;

int activeTouches = 0;
int fadeOutRenderNum = 0;


class RenderObject
{
public:
    virtual void update() = 0;
    virtual void draw() = 0;
    virtual void fadeOutUpdate() = 0;
    virtual float getXPos() = 0;
    virtual float getYPos() = 0;
    virtual float getRed() = 0;
    virtual float getGreen() = 0;
    virtual float getBlue() = 0;
};


class Flare : public RenderObject
{
public:
    Flare();
    Flare(float width, float height, int touchNum);
    
    virtual void update();
    virtual void draw();
    
    void fadeOutUpdate();
    
    float getXPos() {
        return x;
    }
    
    float getYPos() {
        return y;
    }
    
    void setColor(float _r, float _g, float _b, float _a)
    {
        r = _r;
        g = _g;
        b = _b;
        a = _a;
    }
    
    void setAlpha(float _a) {
        a = _a;
    }
    
    float getAlpha() {
        return a;
    }
    
    float getRed() {
        return r;
    }
    
    float getGreen() {
        return g;
    }
    
    float getBlue() {
        return b;
    }
    
    void setPosition(float _x, float _y, float _z)
    {
        x = _x;
        y = _y;
        z = _z;
    }
    
    void setTexture(GLuint _tex)
    {
        tex = _tex;
    }
    
private:
    float r, g, b, a;
    float x, y, z;
    float rotation;
    
    int flareColorNum = 10;
    GLKVector3 _flareColors[10] = {
        {1.0, 0.0, 0.0},
        {0.0, 1.0, 0.0},
        {0.0, 0.0, 1.0},
        {1.0, 0.0, 1.0},
        {0.0, 1.0, 1.0},
        {1.0, 1.0, 0.0},
        {1.0, 1.0, 1.0},
        {0.75, 0.0, 0.5},
        {0.66, 0.33, 1},
        {0.0, 0.85, 0.4}
    };
    // geometry
    GLfloat geo[4*2];
    // texture coordinates
    GLfloat texcoord[4*2];
    // pointer to texture
    GLuint tex;
    
};


Flare::Flare()
{
    tex = loadOrRetrieveTexture(@"flare.png");
    
    float width = 0.5;
    float height = 0.5;
    
    r = g = b = a = 1;
    x = y = z = 0;
    
    // lower left corner
    geo[0] = -width/2.0; geo[1] = -height/2.0;
    // lower right corner
    geo[2] =  width/2.0; geo[3] = -height/2.0;
    // top left corner
    geo[4] = -width/2.0; geo[5] =  height/2.0;
    // upper right corner
    geo[6] =  width/2.0; geo[7] =  height/2.0;
    
    rotation = 0;
}

Flare::Flare(float width, float height, int touchNum)
{
    tex = loadOrRetrieveTexture(@"flare.png");
    GLKVector3 _color = _flareColors[(int)(Random::unit()*flareColorNum)];
    r = _color.x;
    g = _color.y;
    b = _color.z;
    a = 1;
    
    x = y = z = 0;
    // lower left corner
    geo[0] = -width/2.0; geo[1] = -height/2.0;
    // lower right corner
    geo[2] =  width/2.0; geo[3] = -height/2.0;
    // top left corner
    geo[4] = -width/2.0; geo[5] =  height/2.0;
    // upper right corner
    geo[6] =  width/2.0; geo[7] =  height/2.0;
    
    // set up texcoords / uv
    texcoord[0] = 0; texcoord[1] = 0;
    texcoord[2] = 1; texcoord[3] = 0;
    texcoord[4] = 0; texcoord[5] = 1;
    texcoord[6] = 1; texcoord[7] = 1;
    
    rotation = 0;
}

void Flare::update()
{
    rotation += M_PI/70.0;
}

void Flare::fadeOutUpdate()
{
    rotation += M_PI/120;
    a = a * 0.993;
}

void Flare::draw()
{
    glUseProgram(_texShaderProgram);
    
    glEnable(GL_TEXTURE_2D);
    
    //GLKMatrix4Translate(GLKMatrix4 matrix, float tx, float ty, float tz)
    //GLKMatrix4Scale(GLKMatrix4 matrix, float sx, float sy, float sz)
    GLKMatrix4 myModelView = GLKMatrix4Translate(modelView, x, y, z);
    myModelView = GLKMatrix4Rotate(myModelView, rotation, 0, 0, 1);
    myModelView = GLKMatrix4Scale(myModelView, 1+0.25*sin(rotation), 1+0.25*sin(rotation), 1);
    
    
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, geo);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 0, texcoord);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    
    glBindTexture(GL_TEXTURE_2D, tex);
    glUniform1f(_texTexUniform, 0);
    
    glVertexAttrib4f(GLKVertexAttribColor, r, g, b, a);
    glVertexAttrib3f(GLKVertexAttribNormal, 0, 0, 1);
    
    GLKMatrix4 mvp = GLKMatrix4Multiply(projection, myModelView);
    GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(myModelView), NULL);
    glUniformMatrix4fv(_texMvpUniform, 1, GL_FALSE, mvp.m);
    glUniformMatrix3fv(_texNormalMatrixUniform, 1, GL_FALSE, normalMatrix.m);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}


@interface ViewController ()
{
    float _rotation [4];
    
    std::list<RenderObject *> renderList;
    std::list<RenderObject *> fadeOutRenderList;
    std::map<UITouch *, Flare *> touchFlares;
    //std::list<GLKVector2[WAVEFORM_GEO_SIZE]> waveFormGeos;
    
    GLKVector2 _mainWaveFormGeo[WAVEFORM_GEO_SIZE];
    GLKVector2 _waveFormGeo1[WAVEFORM_GEO_SIZE];
    GLKVector2 _waveFormGeo2[WAVEFORM_GEO_SIZE];
    GLKVector2 _waveFormGeo3[WAVEFORM_GEO_SIZE];
    GLKVector2 _waveFormGeo4[WAVEFORM_GEO_SIZE];
    GLKVector2 _waveFormGeo5[WAVEFORM_GEO_SIZE];
    GLKVector2 _flareLocations[20];
    GLKVector2 _flareLocationTranslation[WAVEFORM_GEO_SIZE];
}

@property (strong, nonatomic) EAGLContext *context;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [self setupGL];
    
    _shaderProgram = createProgramWithDefaultAttributes(@"Shader.vsh", @"Shader.fsh");
    _mvpUniform = glGetUniformLocation(_shaderProgram, "modelViewProjectionMatrix");
    _normalMatrixUniform = glGetUniformLocation(_shaderProgram, "normalMatrix");
    
    _texShaderProgram = createProgramWithDefaultAttributes(@"TextureShader.vsh", @"TextureShader.fsh");
    _texMvpUniform = glGetUniformLocation(_texShaderProgram, "modelViewProjectionMatrix");
    _texNormalMatrixUniform = glGetUniformLocation(_texShaderProgram, "normalMatrix");
    _texTexUniform = glGetUniformLocation(_texShaderProgram, "tex");
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glEnable(GL_DEPTH_TEST);
}


- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
}


- (void)update
{
    for (int i = 1; i <= 4; i++) {
        _rotation[i-1] += (0.005 * i);
    }
    
    for(auto r = renderList.begin(); r != renderList.end(); r++)
        (*r)->update();
    
    for(auto r = fadeOutRenderList.begin(); r != fadeOutRenderList.end(); r++) {
        (*r)->fadeOutUpdate();
    }
}


// render
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.1, 0.1, 0.1, 1.0);
    glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    
    glDisable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    // normal alpha blending
    // glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    // additive blending
    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
    
    // set up projection matrix
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    projection = GLKMatrix4MakeFrustum(-1, 1, -1/aspect, 1/aspect, 0.1, 100);
    modelView = GLKMatrix4Identity;
    modelView = GLKMatrix4Translate(modelView, 0, 0, -0.101);
    
    int audioFrameSize = [[AudioManager instance] lastAudioBufferSize];
    assert (audioFrameSize <= WAVEFORM_GEO_SIZE);
    
    //float *audioFrame = [[AudioManager instance] lastAudioBuffer];
    
    //    for(int i = 0; i < audioFrameSize; i++) {
    //        // GL coordinates are -1 - 1
    //        float x = ((float)i)/audioFrameSize * 2.0f - 1.0f;
    //        _mainWaveFormGeo[i].x = x;
    //        _mainWaveFormGeo[i].y = audioFrame[i];
    //    }
    
    if(activeTouches) {
        //  distribute the points to be where they need to be
        //        int largeHop = (int)(audioFrameSize / (activeTouches - 1));
        //
        //        for(int pointNum = 1; pointNum < audioFrameSize-1; pointNum++){
        //            _flareLocationTranslation[pointNum] = GLKVector2Add(_flareLocationTranslation[pointNum-1], smallHop);
        //        }
        int largeHop = (int)(audioFrameSize / activeTouches);
        int i = 0;
        for(auto r = renderList.begin(); r != renderList.end(); r++){
            _flareLocations[i].x = _flareLocationTranslation[i*largeHop].x = (*r)->getXPos();
            _flareLocations[i].y = _flareLocationTranslation[i*largeHop].y = (*r)->getYPos();
            i++;
        }
        GLKVector2 smallHop = GLKVector2Subtract(_flareLocations[0], _flareLocations[1]);
        // for every line between each flare
        for(int hi = 0; hi < (activeTouches - 2); hi++){
            // for each point on a single line
            GLKVector2 smallHop = GLKVector2Subtract(_flareLocations[hi+1], _flareLocations[hi]);
            
            smallHop.x = smallHop.x/largeHop;
            smallHop.y = smallHop.y/largeHop;
            
            for(int pointNum = hi * largeHop; pointNum < (hi + 1) * largeHop; pointNum++){
                _flareLocationTranslation[pointNum] = GLKVector2Add(_flareLocationTranslation[pointNum-1], smallHop);
            }
        }
    }
    

else{
    for(int i = 0; i < audioFrameSize; i++){
        _flareLocationTranslation[i].x = _flareLocations[0].x;
        _flareLocationTranslation[i].y = _flareLocations[0].y;
    }
}


if(activeTouches) {
    float *voice1Frame = [[AudioManager instance] lastVoice1Buffer];
        for(int i = 0; i < audioFrameSize; i++){
            float x = (((float)i)/audioFrameSize * 2.0f) - 1.0f;
            _waveFormGeo1[i].x = x + _flareLocationTranslation[0].x;
            _waveFormGeo1[i].y = voice1Frame[i] + _flareLocationTranslation[0].y;
        }
        
        if(activeTouches > 1){
            float *voice2Frame = [[AudioManager instance] lastVoice2Buffer];
            for(int i = 0; i < audioFrameSize; i++){
                float x = ((float)i)/audioFrameSize * 2.0f - 1.0f;
                _waveFormGeo2[i].x = x + _flareLocationTranslation[1].x;
                _waveFormGeo2[i].y = voice2Frame[i] + _flareLocationTranslation[1].y;
            }
            
            if(activeTouches > 2){
                float *voice3Frame = [[AudioManager instance] lastVoice3Buffer];
                for(int i = 0; i < audioFrameSize; i++){
                    float x = ((float)i)/audioFrameSize * 2.0f - 1.0f;
                    _waveFormGeo3[i].x = x + _flareLocations[2].x;
                    _waveFormGeo3[i].y = voice3Frame[i]  + _flareLocations[2].y;
                }
                
                if(activeTouches > 3){
                    float *voice4Frame = [[AudioManager instance] lastVoice4Buffer];
                    for(int i = 0; i < audioFrameSize; i++){
                        float x = ((float)i)/audioFrameSize * 2.0f - 1.0f;
                        _waveFormGeo4[i].x = x + _flareLocations[3].x;
                        _waveFormGeo4[i].y = voice4Frame[i]  + _flareLocations[3].y;
                    }
                    
                    if(activeTouches > 4){
                        float *voice5Frame = [[AudioManager instance] lastVoice5Buffer];
                        for(int i = 0; i < audioFrameSize; i++){
                            float x = ((float)i)/audioFrameSize * 2.0f - 1.0f;
                            _waveFormGeo5[i].x = x + _flareLocations[4].x;
                            _waveFormGeo5[i].y = voice5Frame[i] + _flareLocations[4].y;
                        }
                    }
                }
            }
        }
         
//        for ( int i = 0; i < audioFrameSize; i++ ) {
//            _mainWaveFormGeo[i] = GLKVector2Add(_mainWaveFormGeo[i], _flareLocations[i]);
//        }
    }
    
    // setup projection and normal matrix for rendering waveforms
    GLKMatrix4 mvp = GLKMatrix4Multiply(projection, modelView);
    GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelView), NULL);
    glUniformMatrix4fv(_texMvpUniform, 1, GL_FALSE, mvp.m);
    glUniformMatrix3fv(_texNormalMatrixUniform, 1, GL_FALSE, normalMatrix.m);

    int i = 0;
    for (auto r = renderList.begin(); r != renderList.end(); r++){
        
        glUseProgram(_shaderProgram);
        if(i == 0)
        {
            glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, _waveFormGeo1);
        }
        else if(i == 1)
        {
            glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, _waveFormGeo2);
        }
        else if(i == 2)
        {
            glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, _waveFormGeo3);
        }
        else if(i == 3)
        {
            glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, _waveFormGeo4);
        }
        else if(i == 4)
        {
            glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, _waveFormGeo5);
        }
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glVertexAttrib3f(GLKVertexAttribColor, (*r)->getRed(), (*r)->getGreen(), (*r)->getBlue());
        glUniformMatrix4fv(_texMvpUniform, 1, GL_FALSE, mvp.m);
        glUniformMatrix3fv(_texNormalMatrixUniform, 1, GL_FALSE, normalMatrix.m);
        glDrawArrays(GL_LINE_STRIP, 0, audioFrameSize);
        i++;
    }
    // render the Flares
    for(auto r = renderList.begin(); r != renderList.end(); r++)
        (*r)->draw();
    for(auto r = fadeOutRenderList.begin(); r != fadeOutRenderList.end(); r++)
        (*r)->draw();
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for(UITouch *touch in touches)
    {
        CGPoint p = [touch locationInView:self.view];
        
        int viewport[] = { (int)self.view.bounds.origin.x, (int)self.view.bounds.origin.y,
            (int)self.view.bounds.size.width, (int)self.view.bounds.size.height };
        bool success;
        GLKVector3 vec = GLKMathUnproject(GLKVector3Make(p.x, self.view.bounds.size.height-p.y, 0.1),
                                          modelView, projection, viewport, &success);
        NSLog(@"began: %f %f %f", vec.x, vec.y, vec.z);
        
        activeTouches = activeTouches + 1;
        touchFlares[touch] = new Flare(1, 1, activeTouches);
        touchFlares[touch]->setPosition(vec.x, vec.y, vec.z);
        
        renderList.push_back(touchFlares[touch]);
        
        AudioManager *audioManager = [AudioManager instance];
        [audioManager setSynthesisState:activeTouches];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for(UITouch *touch in touches)
    {
        CGPoint p = [touch locationInView:self.view];
        
        int viewport[] = { (int)self.view.bounds.origin.x, (int)self.view.bounds.origin.y,
            (int)self.view.bounds.size.width, (int)self.view.bounds.size.height };
        bool success;
        GLKVector3 vec = GLKMathUnproject(GLKVector3Make(p.x, self.view.bounds.size.height-p.y, 0.1),
                                          modelView, projection, viewport, &success);
        // NSLog(@"move: %f %f %f", vec.x, vec.y, vec.z);
        // [audioManager setAMFreq:vec.x];
        touchFlares[touch]->setPosition(vec.x, vec.y, vec.z);
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for(UITouch *touch in touches)
    {
        //CGPoint p = [touch locationInView:self.view];
        
        //int viewport[] = { (int)self.view.bounds.origin.x, (int)self.view.bounds.origin.y,
        //   (int)self.view.bounds.size.width, (int)self.view.bounds.size.height };
        // bool success;
        //        GLKVector3 vec = GLKMathUnproject(GLKVector3Make(p.x, self.view.bounds.size.height-p.y, 0.1),
        //                                          modelView, projection, viewport, &success);
        
        fadeOutRenderList.push_back(touchFlares[touch]);
        fadeOutRenderNum += 1;
        renderList.remove(touchFlares[touch]);
        AudioManager *audioManager = [AudioManager instance];
        activeTouches = activeTouches - 1;
        if (activeTouches < 0){activeTouches = 0;};
        [audioManager setSynthesisState:activeTouches];
    }
}

@end