#include "ruby.h"

static VALUE mPuddle;
static VALUE mClassMethods;
ID objectsIvarId;

VALUE puddleCollectionsPerClass;

static VALUE puddleSetup(VALUE self, VALUE number)
{
  VALUE instancePoolForClass = rb_ary_new();
  rb_hash_aset(puddleCollectionsPerClass, self, instancePoolForClass);

  for(int i = 0; i < NUM2INT(number); i++)
  {
    VALUE instance = rb_class_new_instance(0, NULL, self);
    rb_ary_push(instancePoolForClass, instance);
  }

  return Qnil;
}

static VALUE puddleBorrow(VALUE self)
{
  VALUE instancePoolForClass = rb_hash_aref(puddleCollectionsPerClass, self);
  return rb_ary_pop(instancePoolForClass);
}

static VALUE puddleReturn(VALUE self, VALUE obj)
{
  VALUE instancePoolForClass = rb_hash_aref(puddleCollectionsPerClass, self);
  return rb_ary_push(instancePoolForClass, obj);
}

void Init_puddle_ext() {	
	mPuddle = rb_define_module("Puddle");
	mClassMethods = rb_define_module_under(mPuddle, "FastClassMethods");
  
  rb_define_method(mClassMethods, "borrow", puddleBorrow, 0);
  rb_define_method(mClassMethods, "return", puddleReturn, 1);
  rb_define_method(mClassMethods, "setup", puddleSetup, 1);

  puddleCollectionsPerClass = rb_hash_new();
  rb_funcall(puddleCollectionsPerClass, rb_intern("compare_by_identity"), 0);
  rb_ivar_set(mPuddle, objectsIvarId, puddleCollectionsPerClass);

  CONST_ID(objectsIvarId, "@_objects");
}

