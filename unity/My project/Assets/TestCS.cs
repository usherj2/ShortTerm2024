using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public struct Agent
	{
		public Vector2 position;
		public float angle;
	}

public class TestCS : MonoBehaviour
{
    public ComputeShader computeShader;
    public RenderTexture renderTexture;
    ComputeBuffer agentBuffer;

    public int width = 1280;
    public int height = 720;
    public int numAgents = 100;

    // Start is called before the first frame update
    void Start()
    {
        int kernelHandle = computeShader.FindKernel("Update");

        Agent[] agents = new Agent[numAgents];
		for (int i = 0; i < agents.Length; i++)
		{
			Vector2 center = new Vector2(width / 2, height / 2);
			Vector2 startPos = Vector2.zero;
			float randomAngle = Random.value * Mathf.PI * 2;
			float angle = 0;

            agents[i] = new Agent() { position = startPos, angle = angle };
        }
        //CreateStructuredBuffer<agent>(ref agentBuffer, agents.Length);
        int stride = System.Runtime.InteropServices.Marshal.SizeOf(typeof(Agent));
        agentBuffer = new ComputeBuffer(agents.Length, stride);

        agentBuffer.SetData(agents);
        computeShader.SetBuffer(kernelHandle, "agents", agentBuffer);
    }
    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        int kernelHandle = computeShader.FindKernel("Update");
        if (renderTexture == null){
            renderTexture = new RenderTexture(width,height,0);
            renderTexture.enableRandomWrite = true;
            renderTexture.Create();
        }
        /*
        computeShader.SetFloat("deltaTime", Time.fixedDeltaTime);
		computeShader.SetFloat("time", Time.fixedTime);
        computeShader.SetInt("width", width);
		computeShader.SetInt("height", height);
        computeShader.SetInt("numAgents", numAgents);
        computeShader.SetTexture(kernelHandle, "Result", renderTexture);
        computeShader.Dispatch(kernelHandle, renderTexture.width / 8, renderTexture.height / 8, 1);

        // Read pixels from the source RenderTexture, apply the material, copy the updated results to the destination RenderTexture
        */
        Update();
        renderTexture = RunSimulation();
        Graphics.Blit(renderTexture, dest);
    }
    // Update is called once per frame
    void Update()
    {   
        RunSimulation();
    }

    RenderTexture RunSimulation(){

        int kernelHandle = computeShader.FindKernel("Update");
        
        if (renderTexture == null){
            renderTexture = new RenderTexture(width,height,0);
            renderTexture.enableRandomWrite = true;
            renderTexture.Create();
        }

        computeShader.SetFloat("deltaTime", Time.fixedDeltaTime);
		computeShader.SetFloat("time", Time.fixedTime);
        computeShader.SetInt("width", width);
		computeShader.SetInt("height", height);
        computeShader.SetInt("numAgents", numAgents);

        computeShader.SetTexture(kernelHandle, "Result", renderTexture);
        computeShader.Dispatch(kernelHandle, renderTexture.width / 8, renderTexture.height / 8, 1);

        return renderTexture;
    }
    void OnDestroy()
	{
		agentBuffer.Dispose();
	}
}
