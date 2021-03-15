#include <stdio.h>
#include <assert.h>
#include <cuda_runtime.h>
#include "helper.h"

template <typename T>
__global__ void testKernel(T val)
{
    printf("\n my value = %d\n", val);
}

template <typename T>
struct Base
{
    Base(){
        cudaStreamCreate(&m_stream);
        m_value = 77;
    };

    virtual void launch() = 0;

protected:
    cudaStream_t m_stream;
    T m_value;
};

template<typename T>
struct Derived: public Base<T>
{
    Derived() : Base<T>(){

    }

    virtual void launch() override{
        testKernel<T><<<1,1,0, this->m_stream>>>(this->m_value);
    }
};



int main(int argc, char **argv)
{     
    Derived<int> d;
    d.launch();

    CUDA_ERROR(cudaDeviceSynchronize());
    return EXIT_SUCCESS;
}

