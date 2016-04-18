//
//  ViewController.m
//  BiTDEPH Synthesizer
//
//  Created by Nathan Villicaña-Shaw on 2/11/16.
//  Copyright © 2016 Nathan Villicaña-Shaw. All rights reserved.
//

#import "ViewController.h"
#import "ShaderHelper.h"
#import "Texture.h"

#import "AudioManager.h"

#import <vector>
#import <list>
#import <map>

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

class RenderObject
{
public:
    virtual void update() = 0;
    virtual void draw() = 0;
};



class Rectangle : public RenderObject
{
public:
    Rectangle();
    Rectangle(float width, float height);
    
    virtual void update();
    virtual void draw();
    
    void setColor(float _r, float _g, float _b, float _a)
    {
        r = _r;
        g = _g;
        b = _b;
        a = _a;
    }
    
    void setPosition(float _x, float _y, float _z)
    {
        x = _x;
        y = _y;
        z = _z;
    }
    
private:
    float r, g, b, a;
    float x, y, z;
    
    GLfloat geo[4*2];
};

Rectangle::Rectangle()
{
    float width = 1;
    float height = 1;
    
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
}

Rectangle::Rectangle(float width, float height)
{
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
}

void Rectangle::update()
{
    
}

void Rectangle::draw()
{
    glUseProgram(_shaderProgram);
    
    //GLKMatrix4Translate(GLKMatrix4 matrix, float tx, float ty, float tz)
    //GLKMatrix4Scale(GLKMatrix4 matrix, float sx, float sy, float sz)
    GLKMatrix4 myModelView = GLKMatrix4Translate(modelView, x, y, z);
    
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, geo);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    glVertexAttrib4f(GLKVertexAttribColor, r, g, b, a);
    glVertexAttrib3f(GLKVertexAttribNormal, 0, 0, 1);
    
    GLKMatrix4 mvp = GLKMatrix4Multiply(projection, myModelView);
    GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(myModelView), NULL);
    glUniformMatrix4fv(_mvpUniform, 1, GL_FALSE, mvp.m);
    glUniformMatrix3fv(_normalMatrixUniform, 1, GL_FALSE, normalMatrix.m);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}


class Pizza : public RenderObject
{
public:
    Pizza();
    Pizza(float width, float height);
    
    virtual void update();
    virtual void draw();
    
    void setColor(float _r, float _g, float _b, float _a)
    {
        r = _r;
        g = _g;
        b = _b;
        a = _a;
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
    
    // geometry
    GLfloat geo[4*2];
    // texture coordinates
    GLfloat texcoord[4*2];
    // pointer to texture
    GLuint tex;
};

Pizza::Pizza()
{
    tex = loadOrRetrieveTexture(@"pizza.png");
    
    float width = 1;
    float height = 1;
    
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

Pizza::Pizza(float width, float height)
{
    tex = loadOrRetrieveTexture(@"pizza.png");
    
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
    
    // set up texcoords / uv
    texcoord[0] = 0; texcoord[1] = 0;
    texcoord[2] = 1; texcoord[3] = 0;
    texcoord[4] = 0; texcoord[5] = 1;
    texcoord[6] = 1; texcoord[7] = 1;
    
    rotation = 0;
}

void Pizza::update()
{
    rotation += M_PI*2/60.0;
}

void Pizza::draw()
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
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}
@interface ViewController ()
{
    float _rotation [4];
    
    std::list<RenderObject *> renderList;
    std::map<UITouch *, Pizza *> touchPizzas;
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
    
    // Rectangle *r;
    
    //    r = new Rectangle(1, 1);
    //    r->setPosition(0, 0, 0);
    //    r->setColor(0.11, 0.9, 0.09, 0.8);
    //    
    //    renderList.push_back(r);
    //    
    //    r = new Rectangle(0.25, 1.75);
    //    r->setPosition(0, 0.62, 0);
    //    r->setColor(0.9, 0.4, 0.12, 0.8);
    //    
    //    renderList.push_back(r);
    //    
    //    r = new Rectangle(1.2, 0.8);
    //    r->setPosition(0, -0.62, 0);
    //    r->setColor(0.6, 0.1, 0.9, 0.8);
    //    
    //    renderList.push_back(r);
    
    // GLuint tex = loadOrRetrieveTexture(@"pizza.png");
    
    //    Pizza *p = new Pizza(1, 1);
    //    p->setColor(0.9, 0.4, 0.12, 0.8);
    //    p->setPosition(0, 0, 0);
    //    p->setTexture(tex);
    //
    //    renderList.push_back(p);
    //    
    //    p = new Pizza(1, 1);
    //    p->setPosition(-0.5, 0.2, 0);
    //    p->setColor(0.11, 0.9, 0.09, 0.8);
    //    p->setTexture(tex);
    //
    //    renderList.push_back(p);
    //    
    //    p = new Pizza(1, 1);
    //    p->setPosition(1.0, -0.7, 0);
    //    p->setColor(0.6, 0.1, 0.9, 0.8);
    //    p->setTexture(tex);
    //
    //    renderList.push_back(p);
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


// update
- (void)update
{
    for (int i = 1; i <= 4; i++) {
    _rotation[i-1] += (0.005 * i);
    }
    
    for(auto r = renderList.begin(); r != renderList.end(); r++)
        (*r)->update();
    
//    rekt.setPosition(sin(_rotation), 0, -0.101);
}


// render
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.1, 0.1, 0.1, 1.0);
    glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
    
    glDisable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    // normal alpha blending
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    // additive blending
    glBlendFunc(GL_SRC_ALPHA, GL_ONE);
    
    // set up projection matrix
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    projection = GLKMatrix4MakeFrustum(-1, 1, -1/aspect, 1/aspect, 0.1, 100);
    modelView = GLKMatrix4Identity;
    modelView = GLKMatrix4Translate(modelView, 0, 0, -0.101);
    
    for(auto r = renderList.begin(); r != renderList.end(); r++)
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
        
        touchPizzas[touch] = new Pizza(1, 1);
        touchPizzas[touch]->setPosition(vec.x, vec.y, vec.z);
        
        renderList.push_back(touchPizzas[touch]);
        
        AudioManager *audioManager = [AudioManager instance];
        activeTouches = activeTouches + 1;
        //[audioManager setMasterGain:0.9];
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
        //NSLog(@"move: %f %f %f", vec.x, vec.y, vec.z);
        
        touchPizzas[touch]->setPosition(vec.x, vec.y, vec.z);
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
        CGPoint p = [touch locationInView:self.view];
        
        int viewport[] = { (int)self.view.bounds.origin.x, (int)self.view.bounds.origin.y,
            (int)self.view.bounds.size.width, (int)self.view.bounds.size.height };
        bool success;
        GLKVector3 vec = GLKMathUnproject(GLKVector3Make(p.x, self.view.bounds.size.height-p.y, 0.1),
                                          modelView, projection, viewport, &success);
        //NSLog(@"end: %f %f %f", vec.x, vec.y, vec.z);
        
        renderList.remove(touchPizzas[touch]);
        AudioManager *audioManager = [AudioManager instance];
        activeTouches = activeTouches - 1;
        if (activeTouches < 0){activeTouches = 0;};
        [audioManager setSynthesisState:activeTouches];
    }
}

@end
