## C#反射

- 反射：就是操作dll文件的一个类库
- 怎么使用：1--查找DLL文件，2--通过Reflection反射类库里的各种方法来操作dll文件

```c#
class Genericity
{
    static void Main(string[] args)
    {
        //加载DLL文件
        //Assembly assembly1 = Assembly.Load("Reflection");//方式一：这个DLL文件要在启动项目下
        // Assembly assembly2 = Assembly.LoadFile(@"完整路径");//方式二：完整路径
        // Assembly assembly3 = Assembly.LoadFrom(@"完整路径");//方式三：完整路径//Reflection
        Assembly assembly4 = Assembly.LoadFrom(@"C:\Users\User\Desktop\C#学习\Reflection\bin\Debug\Reflection.dll");//方式四：完整路径
        Console.ReadLine();
    }
}
```

## 实例化对象并且调用构造方法

```C#
class Genericity
{
    static void Main(string[] args)
    {

        //1、加载DLL文件
        //Assembly assembly1 = Assembly.Load("Reflection");//方式一：这个DLL文件要在启动项目下
        //Assembly assembly2 = Assembly.LoadFile(@"完整路径");//方式二：完整路径
        // Assembly assembly3 = Assembly.LoadFrom(@"Reflection.dll");//方式三：完整路径//Reflection
        Assembly assembly4 = Assembly.LoadFrom(@"C:\Users\User\Desktop\C#学习\Reflection\bin\Debug\Reflection.dll");//方式四：完整路径
        //2、获取指定类型
        Type type = assembly4.GetType("Reflection.ReflectionTest");
        //Console.WriteLine($"{type}");
        Console.WriteLine("Hello World");
        //3、实例化
        object objTest1 = Activator.CreateInstance(type);//动态实例化，调用我们的构造函数
        object objTest2 = Activator.CreateInstance(type, new object[] { "Ant编程" });//动态实例化，调用我们的构造函数
        object objTest3 = Activator.CreateInstance(type,true);//动态实例化，调用私有构造函数
        //查找所有的类、构造函数、构造函数的参数
        foreach(var item in assembly.GetTypes()) //查找所有的类
            {

            }
            foreach(var ctor in type.GetConstructors(BindingFlags.Instance|BindingFlags.NonPublic|BindingFlags.Public))
            {
                foreach(var param in ctor.GetParameters())//获取构造函数中的所有参数
                {
                    Console.WriteLine($"构造方法的参数：{param.ParameterType}");
                }
            }
        Console.Read();
    }
}
namespace Reflection
{
    public class ReflectionTest
    {
        private ReflectionTest()
        {
            Console.WriteLine("private ReflectionTest()");
        }
        public ReflectionTest()
        {
            Console.WriteLine("public ReflectionTest()");
        }
        public ReflectionTest(string name)
        {
            Console.WriteLine($"public ReflectionTest(string {name})");
        }
    }
}
```

## 普通函数的调用和私有函数的调用

```c#
namespace ConsoleApp1
{
    class Start
    {
        static void Main(string[] args)
        {
            Assembly assembly = Assembly.Load("Reflection");
            Type type = assembly.GetType("Reflection.ReflectionTest");
            object obj = Activator.CreateInstance(type,true);
            //调用普通方法
            //as转换的好处，他不报错，类型不对的话就返回null  类似C++的dynamic_cast
            ReflectionTest reflectionTest= obj as ReflectionTest;
            reflectionTest.Show1();
            //调用私有方法
            var method = type.GetMethod("Show2",BindingFlags.Instance|BindingFlags.NonPublic);
            method.Invoke(obj,new object[] { });
            Console.Read();
        }
    }
}
```

## 调用泛型方法

```C#
namespace Reflection
{
    public class ReflectionTest
    {
        //public ReflectionTest()
        //{
        //    Console.WriteLine("public ReflectionTest()");
        //}
        //public ReflectionTest(string name)
        //{
        //    Console.WriteLine($"public ReflectionTest(string {name})");
        //}
        private ReflectionTest()
        {
            Console.WriteLine($"private ReflectionTest()");
        }
        public void Show1()
        {
            Console.WriteLine("这是普通方法");

        }
        private void Show2()
        {
            Console.WriteLine("这是私有方法");

        }

        private void Show3<T>()
        {
            Console.WriteLine("private void Show3<T>()") ;
        }
        private void Show4<T>(int a,T name)
        {
            Console.WriteLine($"private void Show4<T>(int {a},T {name})");
        }
    }
}

namespace ConsoleApp1
{
    class Start
    {
        static void Main(string[] args)
        {
            Assembly assembly = Assembly.Load("Reflection");
            Type type = assembly.GetType("Reflection.ReflectionTest");
            object obj = Activator.CreateInstance(type,true);
            //调用普通方法
            //as转换的好处，他不报错，类型不对的话就返回null
            ReflectionTest reflectionTest= obj as ReflectionTest;
            reflectionTest.Show1();
            //调用私有方法
            var method = type.GetMethod("Show2",BindingFlags.Instance|BindingFlags.NonPublic);
            method.Invoke(obj,new object[] { });

            Console.WriteLine("-------------------泛型方法调用---------------------");
            var method3 = type.GetMethod("Show3", BindingFlags.Instance | BindingFlags.NonPublic);//查找指定方法
            var genericMethod3 = method3.MakeGenericMethod(new Type[] { typeof(int) });//指定泛型参数类型T
            genericMethod3.Invoke(obj, new object[] { });

            var method4 = type.GetMethod("Show4", BindingFlags.Instance | BindingFlags.NonPublic);
            var genericMethod4 = method4.MakeGenericMethod(new Type[] { typeof(string) });//指定泛型参数类型T
            genericMethod4.Invoke(obj, new object[] 
                                  {123,"Ant编程" });
            Console.Read();
        }
    }
}
```

## 创建泛型类和调用泛型方法

```c#
namespace Reflection
{
    public class GenericClass<T,S>
    {
        public void GenericMethod<T>()
        {
            Console.WriteLine("泛型方法");
        }
    }
}

namespace ConsoleApp1
{
    class Start
    {
        static void Main(string[] args)
        {
            //加载dll文件   
            Assembly assembly = Assembly.LoadFrom("Reflection.dll");
            //获取对应的类的类型
            Type type = assembly.GetType("Reflection.GenericClass`2").MakeGenericType(typeof(int), typeof(string));
            object obj = Activator.CreateInstance(type);
            var method = type.GetMethod("GenericMethod").MakeGenericMethod(typeof(int));
            method.Invoke(obj,new object[] { });
            Console.Read();
        }
    }
}
```

## 设置属性的值和获取属性的值

```c#
namespace Reflection
{
    public class GenericClass<T,S>
    {

        public int id { set; get; }
        public string name { set; get; }
        public string age { set; get; }
        public void GenericMethod<T>()
        {
            Console.WriteLine("泛型方法");
        }
    }
}
namespace ConsoleApp1
{
    class Start
    {
        static void Main(string[] args)
        {
            //加载dll文件   
            Assembly assembly = Assembly.LoadFrom("Reflection.dll");
            //获取对应的类的类型
            Type type = assembly.GetType("Reflection.GenericClass`2").MakeGenericType(typeof(int), typeof(string));
            //Type type = assembly.GetType("Reflection.ReflectionTest");
            object obj = Activator.CreateInstance(type);
            //var method = type.GetMethod("GenericMethod").MakeGenericMethod(typeof(int));
            //method.Invoke(obj,new object[] { });
            foreach(var property in type.GetProperties())
            {
                Console.WriteLine("Hello World");
                Console.WriteLine(property.Name);
                if (property.Name.Equals("id"))
                {
                    property.SetValue(obj,123);
                }else if (property.Name.Equals("name"))
                {
                    property.SetValue(obj,"小明");
                }
                else
                {
                    property.SetValue(obj, "男");
                }
                Console.WriteLine(property.GetValue(obj));
            }
            Console.Read();
        }
    }
}
```

![](.\img\123.jpg)
