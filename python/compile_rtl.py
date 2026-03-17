import sys
import filecmp
import subprocess
import sys
import os


# 主函数
def main():
    rtl_dir = r'..\rtl'
    
    temp_dir = r'..\temp'

    #testbench文件路径
    tb_file = r'..\sim\tb.v'

    # iverilog程序
    iverilog_cmd = ['iverilog']
    # 顶层模块  
    # 注意：-s 后面必须是 顶层 module 的名字，而不是文件路径。
    iverilog_cmd += ['-s', 'tb']
    # 编译生成文件
    out_file = os.path.join(temp_dir, 'out.vvp')
    iverilog_cmd += ['-o', out_file]
    # 头文件(defines.v)路径
    iverilog_cmd += ['-I', rtl_dir]
    # 宏定义，仿真输出文件
    signature_file = os.path.join(temp_dir, 'signature.output')
    iverilog_cmd += ['-D', f'OUTPUT="{signature_file}"']
    # testbench文件
    iverilog_cmd.append(tb_file)
    
    # 自动加入rtl_dir目录下的所有rtl .v
    for root, dirs, files in os.walk(rtl_dir):
        for f in files:
            if f.endswith('.v'):
                iverilog_cmd.append(os.path.join(root, f))
                
    #打印最终命令
    print("Compile command:")
    print(" ".join(iverilog_cmd))

    # 自动等待编译结束
    subprocess.run(iverilog_cmd, check=True)
    
    print("\n")
    print("Compile .v succeed！\n")
    

if __name__ == '__main__':
    sys.exit(main())
