//
//  ShaderHelper.h
//  Auragraph
//
//  Created by Spencer Salazar on 8/2/13.
//  Copyright (c) 2013 Spencer Salazar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

GLuint createProgramWithDefaultAttributes(NSString *vshName, NSString *fshName);

BOOL compileShader(GLuint *shader, GLenum type, NSString *file);
BOOL linkProgram(GLuint prog);
BOOL validateProgram(GLuint prog);